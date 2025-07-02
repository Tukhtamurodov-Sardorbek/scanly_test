import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'file_saver_platform_interface.dart';

/// An implementation of [FileSaverPlatform] that uses method channels.
class MethodChannelFileSaver extends FileSaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('file_saver');

  @override
  Future<String?> get platformVersion async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> saveMultipleFilesToDownloadFolder({
    List<Uint8List>? dataList,
    required List<String> fileNameList,
    required List<String> mimeTypeList,
  }) async {
    if (dataList!.length != fileNameList.length)
      throw "function saveMultipleFilesToDownloadFolder: length of 'dataList' is not equal to the length of 'fileNameList'";

    if (dataList.length != mimeTypeList.length)
      throw "function saveMultipleFilesToDownloadFolder: length of 'dataList' is not equal to the length of 'mimeTypeList'";

    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i].isEmpty)
        throw "function saveMultipleFilesToDownloadFolder: dataList item cannot be null";
    }

    for (var i = 0; i < mimeTypeList.length; i++) {
      if (mimeTypeList[i].isEmpty)
        throw "function saveMultipleFilesToDownloadFolder: mimeTypeList item cannot be null";
    }

    var fileNameCount = new Map();
    for (var i = 0; i < fileNameList.length; i++) {
      String? fileName = fileNameList[i];

      if (fileName.length == 0) fileName = "file";

      if (fileNameCount.containsKey(fileName)) {
        fileNameCount[fileName] += 1;
        var extensionIndex = fileName.lastIndexOf('.');
        if (extensionIndex == -1) extensionIndex = fileName.length;

        var extension = '';
        if (extensionIndex < fileName.length)
          extension = fileName.substring(extensionIndex);

        fileName = fileName.substring(0, extensionIndex) +
            '_' +
            fileNameCount[fileName].toString() +
            extension;
      } else {
        fileNameCount[fileName] = 1;
      }

      fileNameList[i] = fileName;
    }

    try {
      await methodChannel.invokeMethod('saveMultipleFiles', {
        "dataList": dataList,
        "fileNameList": fileNameList,
        "mimeTypeList": mimeTypeList
      });
    } on PlatformException {
      rethrow;
    }
  }

  @override
  FutureOr<dynamic> saveImageToGallery(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
    bool isReturnImagePathOfIOS = false,
  }) async {
    final result = await methodChannel
        .invokeMethod('saveImageToGallery', <String, dynamic>{
      'imageBytes': imageBytes,
      'quality': quality,
      'name': name,
      'isReturnImagePathOfIOS': isReturnImagePathOfIOS
    });
    return result;
  }

  @override
  Future saveImageFromFileToGallery(
    String file, {
    String? name,
    bool isReturnPathOfIOS = false,
  }) async {
    final result = await methodChannel.invokeMethod(
        'saveFileToGallery', <String, dynamic>{
      'file': file,
      'name': name,
      'isReturnPathOfIOS': isReturnPathOfIOS
    });
    return result;
  }
}
