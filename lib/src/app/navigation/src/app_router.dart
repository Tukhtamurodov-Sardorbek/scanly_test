import 'dart:typed_data' show Uint8List;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/feature/entry_feature/entry_pages_wrapper.dart';
import 'package:scanly_test/src/app/feature/entry_feature/screens/onboard_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/details_page/details_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/editor_page/editor_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/home_page/home_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/home_page/home_page_wrapper.dart';
import 'package:scanly_test/src/app/feature/home_feature/main_page.dart';
import 'package:scanly_test/src/app/feature/entry_feature/screens/splash_page.dart';
import 'package:scanly_test/src/domain/model/model.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: EntryRoutesWrapper.page,
      children: [
        AutoRoute(path: '', page: SplashRoute.page),
        AutoRoute(path: 'onboard', page: OnboardRoute.page),
      ],
    ),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(
          page: HomeRouter.page,
          children: [
            AutoRoute(path: '', page: HomeRoute.page), // initial: true,
            AutoRoute(
              path: 'details',
              page: DetailsRoute.page,
              meta: const {'fullScreen': true},
            ),
            AutoRoute(
              path: 'editor',
              page: EditorRoute.page,
              meta: const {'fullScreen': true},
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
