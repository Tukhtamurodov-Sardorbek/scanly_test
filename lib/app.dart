import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/domain/core/core.dart';

import 'src/app/app_bloc/app_bloc.dart';

class ScanlyTestApp extends StatelessWidget {
  const ScanlyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) =>
              GetAppBloc.scannerBloc()..add(ScannerEvent.retrieveAllGroups()),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp.router(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: GetAppNavigator.appRouter().config(
            includePrefixMatches: true,
            navigatorObservers: () => [AppRouteObserver()],
            placeholder: (context) {
              return ColoredBox(color: AppColor.primaryBackground);
            },
          ),
          theme: ThemeData.light().copyWith(
            primaryColor: AppColor.primaryTone,
            scaffoldBackgroundColor: AppColor.primaryBackground,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColor.primaryBackground,
              iconTheme: const IconThemeData(color: AppColor.black),
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  overscroll: false,
                  physics: const BouncingScrollPhysics(),
                ),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
