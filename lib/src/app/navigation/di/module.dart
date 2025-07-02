import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';
import 'package:scanly_test/src/app/navigation/src/app_navigator/impl/entry_navigator.dart';
import 'package:scanly_test/src/app/navigation/src/app_navigator/impl/main_navigator.dart';
import 'package:scanly_test/src/app/navigation/src/app_routes/impl/main_routes_impl.dart';
import 'package:scanly_test/src/app/navigation/src/app_routes/main_routes.dart';

@module
abstract class NavigatorModule {
  @singleton
  AppRouter injectAppRouter() => AppRouter();

  @lazySingleton
  EntryNavigator injectEntryNavigator() {
    return EntryNavigatorImpl();
  }

  @lazySingleton
  MainNavigator injectMainNavigator(AppRouter appRouter) {
    return MainNavigatorImpl(appRouter);
  }

  @lazySingleton
  MainRoutes provideMainRoutes() {
    return MainRoutesImpl();
  }
}
