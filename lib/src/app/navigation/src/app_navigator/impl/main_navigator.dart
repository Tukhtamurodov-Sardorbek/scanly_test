import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/navigation/src/app_navigator/main_navigation.dart';
import 'package:scanly_test/src/app/navigation/src/app_router.dart';

class MainNavigatorImpl extends MainNavigator {
  final AppRouter _appRouter;

  MainNavigatorImpl(this._appRouter);

  @override
  Future<void> navigateToMainPage(BuildContext context) {
    return context.router.replaceAll([const MainRoute()]);
  }
}
