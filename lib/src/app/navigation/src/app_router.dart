import 'package:auto_route/auto_route.dart';
import 'package:scanly_test/src/app/feature/entry_feature/entry_pages_wrapper.dart';
import 'package:scanly_test/src/app/feature/entry_feature/screens/onboard_page.dart';
import 'package:scanly_test/src/app/feature/entry_feature/screens/rate_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/details_page/details_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/home_page/home_page.dart';
import 'package:scanly_test/src/app/feature/home_feature/main_page.dart';
import 'package:scanly_test/src/app/feature/entry_feature/screens/splash_page.dart';

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
        AutoRoute(path: 'rate', page: RateRoute.page),
        AutoRoute(path: 'onboard', page: OnboardRoute.page),
      ],
    ),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(
          initial: true,
          page: HomeRoute.page,
          children: [AutoRoute(page: DetailsRoute.page)],
        ),
      ],
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
