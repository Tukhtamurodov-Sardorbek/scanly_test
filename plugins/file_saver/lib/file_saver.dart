import 'dart:async';
import 'dart:typed_data';

import 'file_saver_platform_interface.dart';

class FileSaver {
  FileSaver._();

  static Future<String?> get platformVersion {
    return FileSaverPlatform.instance.platformVersion;
  }

  static Future<void> saveFilesToDownloadFolder({
    List<Uint8List>? dataList,
    required List<String> fileNameList,
    required List<String> mimeTypeList,
  }) async {
    return FileSaverPlatform.instance.saveMultipleFilesToDownloadFolder(
      dataList: dataList,
      fileNameList: fileNameList,
      mimeTypeList: mimeTypeList,
    );
  }

  static Future<void> saveFileToDownloadFolder(
    Uint8List data,
    String fileName,
    String mimeType,
  ) async {
    return FileSaverPlatform.instance.saveMultipleFilesToDownloadFolder(
      dataList: [data],
      fileNameList: [fileName],
      mimeTypeList: [mimeType],
    );
  }

  static FutureOr<dynamic> saveImageToGallery(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
    bool isReturnImagePathOfIOS = false,
  }) async {
    return FileSaverPlatform.instance.saveImageToGallery(
      imageBytes,
      quality: quality,
      name: name,
      isReturnImagePathOfIOS: isReturnImagePathOfIOS,
    );
  }

  /// Save the PNG，JPG，JPEG image or video located at [file] to the local device media gallery.
  static Future saveImageFromFileToGallery(
    String file, {
    String? name,
    bool isReturnPathOfIOS = false,
  }) async {
    return FileSaverPlatform.instance.saveImageFromFileToGallery(
      file,
      name: name,
      isReturnPathOfIOS: isReturnPathOfIOS,
    );
  }
}
