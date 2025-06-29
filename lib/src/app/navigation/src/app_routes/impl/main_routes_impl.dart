import 'package:auto_route/auto_route.dart';
import 'package:scanly_test/src/app/navigation/src/app_router.dart';
import 'package:scanly_test/src/app/navigation/src/app_routes/main_routes.dart';

class MainRoutesImpl extends MainRoutes {
  @override
  PageRouteInfo getHomeRouter() => const HomeRoute();
}
