import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanly_test/app.dart';
import 'package:scanly_test/di/injector.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/domain/core/core.dart';

void main() {
  runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ),
      );

      await Future.wait<dynamic>([
        EasyLocalization.ensureInitialized(),
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      ]);

      configureDependencies();

      if (kDebugMode) {
        Bloc.observer = AppBlocObserver();
      }

      runApp(
        ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          useInheritedMediaQuery: true,
          designSize: const Size(390, 844),
          child: const ScanlyTestApp(),
          builder: (context, child) {
            FlutterNativeSplash.remove();
            return EasyLocalization(
              useOnlyLangCode: true,
              useFallbackTranslations: true,
              path: AppLocaleConfig.localePath,
              fallbackLocale: const Locale(AppLocaleConfig.fallbackLocale),
              supportedLocales: AppLocale.values
                  .map((e) => Locale(e.languageCode))
                  .toList(),
              child: child!,
            );
          },
        ),
      );
    },
    (error, stack) {
      debugPrintStack(stackTrace: stack, label: error.toString());
    },
  );
}
