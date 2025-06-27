import 'package:get_it/get_it.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';
import 'package:scanly_test/src/app/navigation/src/app_routes/main_routes.dart';

mixin GetAppNavigator {
  static AppRouter appRouter() {
    return GetIt.I.get<AppRouter>();
  }

  static EntryNavigator entryNavigator() {
    return GetIt.I.get<EntryNavigator>();
  }

  static MainNavigator mainNavigator() {
    return GetIt.I.get<MainNavigator>();
  }
}

mixin GetAppRoute {
  static PageRouteInfo get homeRouter {
    return GetIt.I.get<MainRoutes>().getHomeRouter();
  }
  static PageRouteInfo get detailsRouter {
    return GetIt.I.get<MainRoutes>().getDetailsRouter();
  }
}
