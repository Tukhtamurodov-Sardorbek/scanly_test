import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_saver/file_saver_platform_interface.dart';
import 'package:file_saver/file_saver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFileSaverPlatform
    with MockPlatformInterfaceMixin
    implements FileSaverPlatform {
  @override
  Future<String?> get platformVersion => Future.value('42');

  @override
  Future<void> saveMultipleFilesToDownloadFolder({
    List<Uint8List>? dataList,
    required List<String> fileNameList,
    required List<String> mimeTypeList,
  }) async {}

  @override
  FutureOr saveImageToGallery(
    Uint8List imageBytes, {
    int quality = 80,
    String? name,
    bool isReturnImagePathOfIOS = false,
  }) {}

  @override
  Future saveImageFromFileToGallery(
    String file, {
    String? name,
    bool isReturnPathOfIOS = false,
  }) async {}
}

void main() {
  final FileSaverPlatform initialPlatform = FileSaverPlatform.instance;

  test('$MethodChannelFileSaver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFileSaver>());
  });

  test('getPlatformVersion', () async {
    final fakePlatform = MockFileSaverPlatform();
    FileSaverPlatform.instance = fakePlatform;

    expect(await FileSaver.platformVersion, '42');
  });
}
