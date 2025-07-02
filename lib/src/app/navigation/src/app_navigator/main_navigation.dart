import 'package:flutter/material.dart';
import 'package:scanly_test/src/domain/model/model.dart';

abstract class MainNavigator {
  Future<void> navigateToMainPage(BuildContext context);

  Future<void> navigateToDetailsPage({
    required String title,
    required ScanGroup group,
  });

  Future<void> navigateToEditorPage({
    required String imagePath,
    required ScanGroup group,
    String? thumbnailPath,
  });
}
