package com.example.file_saver

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Environment.DIRECTORY_DOWNLOADS
import android.os.ParcelFileDescriptor
import android.provider.MediaStore
import android.text.TextUtils
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException

/** FileSaverPlugin */
class FileSaverPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.RequestPermissionsResultListener {
  private val REQ_CODE = 39285
  private var currentActivity: Activity? = null
  private var call: MethodCall? = null
  private var result: Result? = null
  private lateinit var context: Context

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "file_saver")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    this.call = call
    this.result = result

    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "saveMultipleFiles") {
      var permissionGranted = true

      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q && ActivityCompat.checkSelfPermission(
          currentActivity!!,
          Manifest.permission.WRITE_EXTERNAL_STORAGE
        ) != PackageManager.PERMISSION_GRANTED
      )
        permissionGranted = false

      if (permissionGranted) {
        val dataList: List<ByteArray> = call.argument("dataList")!!
        val fileNameList: List<String> = call.argument("fileNameList")!!
        val mimeTypeList: List<String> = call.argument("mimeTypeList")!!
        saveMultipleFiles(dataList, fileNameList, mimeTypeList)
        result.success(null)
      } else {
        ActivityCompat.requestPermissions(
          currentActivity!!,
          arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
          REQ_CODE
        )
      }

    } else if (call.method == "saveImageToGallery") {
      val image = call.argument<ByteArray>("imageBytes") ?: return
      val quality = call.argument<Int>("quality") ?: return
      val name = call.argument<String>("name")

      result.success(
        saveImageToGallery(
          BitmapFactory.decodeByteArray(image, 0, image.size),
          quality,
          name,
        )
      )
    } else if (call.method == "saveFileToGallery") {
      val path = call.argument<String>("file") ?: return
      val name = call.argument<String>("name")
      result.success(saveFileToGallery(path, name))
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun saveMultipleFiles(
    dataList: List<ByteArray>,
    fileNameList: List<String>,
    mimeTypeList: List<String>
  ) {
    val length = dataList.count()

    for (i in 0 until length) {
      val data = dataList[i]
      val fileName = fileNameList[i]
      val mimeType = mimeTypeList[i]

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        Log.i("advoques", "save file using MediaStore")

        val values = ContentValues().apply {
          put(MediaStore.Downloads.DISPLAY_NAME, fileName)
          put(MediaStore.Downloads.MIME_TYPE, mimeType)
          put(MediaStore.Downloads.IS_PENDING, 1)
        }

        val resolver = context.contentResolver

        val collection =
          MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)

        val itemUri = resolver.insert(collection, values)

        if (itemUri != null) {
          resolver.openFileDescriptor(itemUri, "w").use { it ->
            ParcelFileDescriptor.AutoCloseOutputStream(it).write(data)
          }
          values.clear()
          values.put(MediaStore.Downloads.IS_PENDING, 0)
          resolver.update(itemUri, values, null, null)
        }
      } else {
        Log.i("advoques", "save file using getExternalStoragePublicDirectory")
        val file = File(
          Environment.getExternalStoragePublicDirectory(DIRECTORY_DOWNLOADS),
          fileName
        )
        val fos = FileOutputStream(file)
        fos.write(data)
        fos.close()
      }
    }
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ): Boolean {
    if (requestCode == this.REQ_CODE) {
      val granted = grantResults[0] == PackageManager.PERMISSION_GRANTED
      if (granted) {
        onMethodCall(call!!, result!!)
      } else {
        result?.error("0", "Permission denied", null)
      }
      return granted
    }

    return false
  }

  private fun saveImageToGallery(
    bmp: Bitmap,
    quality: Int,
    name: String?
  ): HashMap<String, Any?> {
    val fileUri = generateUri("jpg", name = name)
    return try {
      val fos = context?.contentResolver?.openOutputStream(fileUri)!!
      println("FileSaverPlugin $quality")
      bmp.compress(Bitmap.CompressFormat.JPEG, quality, fos)
      fos.flush()
      fos.close()
      context!!.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, fileUri))
      bmp.recycle()
      SaveResultModel(fileUri.toString().isNotEmpty(), fileUri.toString(), null).toHashMap()
    } catch (e: IOException) {
      SaveResultModel(false, null, e.toString()).toHashMap()
    }
  }

  private fun saveFileToGallery(filePath: String, name: String?): HashMap<String, Any?> {
    return try {
      val originalFile = File(filePath)
      val fileUri = generateUri(originalFile.extension, name)

      val outputStream = context?.contentResolver?.openOutputStream(fileUri)!!
      val fileInputStream = FileInputStream(originalFile)

      val buffer = ByteArray(10240)
      var count = 0
      while (fileInputStream.read(buffer).also { count = it } > 0) {
        outputStream.write(buffer, 0, count)
      }

      outputStream.flush()
      outputStream.close()
      fileInputStream.close()

      context!!.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, fileUri))
      SaveResultModel(fileUri.toString().isNotEmpty(), fileUri.toString(), null).toHashMap()
    } catch (e: IOException) {
      SaveResultModel(false, null, e.toString()).toHashMap()
    }
  }

  private fun generateUri(extension: String = "", name: String? = null): Uri {
    var fileName = name ?: System.currentTimeMillis().toString()

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      var uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI

      val values = ContentValues()
      values.put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
      values.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
      val mimeType = getMIMEType(extension)
      if (!TextUtils.isEmpty(mimeType)) {
        values.put(MediaStore.Images.Media.MIME_TYPE, mimeType)
        if (mimeType!!.startsWith("video")) {
          uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
          values.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_MOVIES)
        }
      }
      return context.contentResolver?.insert(uri, values)!!
    } else {
      val storePath =
        Environment.getExternalStorageDirectory().absolutePath + File.separator + Environment.DIRECTORY_PICTURES
      val appDir = File(storePath)
      if (!appDir.exists()) {
        appDir.mkdir()
      }
      if (extension.isNotEmpty()) {
        fileName += (".$extension")
      }
      return Uri.fromFile(File(appDir, fileName))
    }
  }

  private fun getMIMEType(extension: String): String? {
    var type: String? = null;
    if (!TextUtils.isEmpty(extension)) {
      type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension.lowercase())
    }
    return type
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    currentActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivity() {
    currentActivity = null
  }
}

class SaveResultModel(
  var isSuccess: Boolean,
  var filePath: String? = null,
  var errorMessage: String? = null
) {
  fun toHashMap(): HashMap<String, Any?> {
    val hashMap = HashMap<String, Any?>()
    hashMap["isSuccess"] = isSuccess
    hashMap["filePath"] = filePath
    hashMap["errorMessage"] = errorMessage
    return hashMap
  }
}