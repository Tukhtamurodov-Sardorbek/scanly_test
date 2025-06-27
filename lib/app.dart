import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/domain/core/core.dart';

class ScanlyTestApp extends StatelessWidget {
  const ScanlyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    late final appRouter = GetAppNavigator.appRouter();
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routerConfig: appRouter.config(
          includePrefixMatches: true,
          navigatorObservers: () => [AppRouteObserver()],
          placeholder: (context) {
            return ColoredBox(color: AppColor.of(context).globalBackground);
          },
        ),
        darkTheme: ThemeData.dark().copyWith(
          extensions: [AppColor.dark],
          primaryColor: AppColor.dark.primaryTone,
          scaffoldBackgroundColor: AppColor.dark.globalBackground,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.dark.globalBackground,
            iconTheme: const IconThemeData(color: AppColor.white),
          ),
        ),
        theme: ThemeData.light().copyWith(
          extensions: [AppColor.light],
          primaryColor: AppColor.light.primaryTone,
          scaffoldBackgroundColor: AppColor.light.globalBackground,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.light.globalBackground,
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
    );
  }
}
