import 'dart:async';
import 'dart:typed_data';
import 'file_saver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FileSaverPlatform extends PlatformInterface {
  /// Constructs a FileSaverPlatform.
  FileSaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static FileSaverPlatform _instance = MethodChannelFileSaver();

  /// The default instance of [FileSaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelFileSaver].
  static FileSaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FileSaverPlatform] when
  /// they register themselves.
  static set instance(FileSaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> get platformVersion {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> saveMultipleFilesToDownloadFolder({
    List<Uint8List>? dataList,
    required List<String> fileNameList,
    required List<String> mimeTypeList,
  }) async {
    throw UnimplementedError(
        'saveMultipleFilesToDownloadFolder() has not been implemented.');
  }

  /// save image to Gallery
  /// imageBytes can't be null
  /// return Map type for example:{"isSuccess":true, "filePath":String?}
  FutureOr<dynamic> saveImageToGallery(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
    bool isReturnImagePathOfIOS = false,
  }) async {
    throw UnimplementedError('saveImageToGallery() has not been implemented.');
  }

  /// Save the PNG，JPG，JPEG image or video located at [file] to the local device media gallery.
  Future saveImageFromFileToGallery(
    String file, {
    String? name,
    bool isReturnPathOfIOS = false,
  }) async {
    throw UnimplementedError(
        'saveImageFromFileToGallery() has not been implemented.');
  }
}
