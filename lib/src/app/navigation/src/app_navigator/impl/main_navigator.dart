import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/navigation/src/app_navigator/main_navigation.dart';
import 'package:scanly_test/src/app/navigation/src/app_router.dart';
import 'package:scanly_test/src/domain/model/model.dart';

class MainNavigatorImpl extends MainNavigator {
  final AppRouter _appRouter;

  MainNavigatorImpl(this._appRouter);

  @override
  Future<void> navigateToMainPage(BuildContext context) {
    return context.router.replaceAll([const MainRoute()]);
  }

  @override
  Future<void> navigateToDetailsPage({
    required String title,
    required ScanGroup group,
  }) {
    return _appRouter.navigate(DetailsRoute(group: group, title: title));
  }

  @override
  Future<void> navigateToEditorPage({
    required String imagePath,
    required ScanGroup group,
    String? thumbnailPath,
  }) {
    return _appRouter.navigate(
      EditorRoute(path: imagePath, thumbnailPath: thumbnailPath, group: group),
    );
  }
}
