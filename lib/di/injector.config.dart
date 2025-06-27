// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart' as _i39;
import 'package:scanly_test/src/app/app_bloc/di/module.dart' as _i238;
import 'package:scanly_test/src/app/navigation/di/module.dart' as _i85;
import 'package:scanly_test/src/app/navigation/navigation.dart' as _i13;
import 'package:scanly_test/src/app/navigation/src/app_routes/main_routes.dart'
    as _i401;
import 'package:scanly_test/src/data/database/database.dart' as _i864;
import 'package:scanly_test/src/data/database/di/module.dart' as _i954;
import 'package:scanly_test/src/data/database/src/storage/app_storage.dart'
    as _i877;
import 'package:scanly_test/src/domain/repository/di/module.dart' as _i1026;
import 'package:scanly_test/src/domain/repository/repository.dart' as _i301;
import 'package:scanly_test/src/domain/usecase/di/module.dart' as _i372;
import 'package:scanly_test/src/domain/usecase/src/entry_usecase.dart' as _i548;
import 'package:scanly_test/src/domain/usecase/usecase.dart' as _i683;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appBLocModule = _$AppBLocModule();
    final databaseModule = _$DatabaseModule();
    final navigatorModule = _$NavigatorModule();
    final repositoryModule = _$RepositoryModule();
    final usecaseModule = _$UsecaseModule();
    gh.factory<_i39.PopHandlerCubit>(
      () => appBLocModule.injectPopHandlerCubit(),
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => databaseModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i13.AppRouter>(() => navigatorModule.injectAppRouter());
    gh.lazySingleton<_i13.EntryNavigator>(
      () => navigatorModule.injectEntryNavigator(),
    );
    gh.lazySingleton<_i401.MainRoutes>(
      () => navigatorModule.provideMainRoutes(),
    );
    gh.singleton<_i877.AppStorage>(
      () => databaseModule.injectAppStorage(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i13.MainNavigator>(
      () => navigatorModule.injectMainNavigator(gh<_i13.AppRouter>()),
    );
    gh.factory<_i301.EntryRepository>(
      () => repositoryModule.injectEntryRepository(gh<_i864.AppStorage>()),
    );
    gh.factory<_i548.EntryUsecase>(
      () => usecaseModule.injectEntryUsecase(gh<_i301.EntryRepository>()),
    );
    gh.factory<_i39.EntryCubit>(
      () => appBLocModule.injectEntryCubit(gh<_i683.EntryUsecase>()),
    );
    return this;
  }
}

class _$AppBLocModule extends _i238.AppBLocModule {}

class _$DatabaseModule extends _i954.DatabaseModule {}

class _$NavigatorModule extends _i85.NavigatorModule {}

class _$RepositoryModule extends _i1026.RepositoryModule {}

class _$UsecaseModule extends _i372.UsecaseModule {}
