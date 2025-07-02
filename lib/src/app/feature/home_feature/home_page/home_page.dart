import 'dart:io' show File, Platform;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/design_system/widgets/bottomsheet.dart';
import 'package:scanly_test/src/app/feature/home_feature/main_page.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/src/domain/model/model.dart';

part 'components/app_bar.dart';

part 'components/body.dart';

part 'components/empty_view.dart';

part 'components/list_tile.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;
  late final RateMyApp _rateMyApp;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _rateMyApp = RateMyApp(
      minDays: 0,
      minLaunches: 2,
      remindLaunches: 1,
      googlePlayIdentifier: 'com.android.chrome',
      appStoreIdentifier: 'com.apple.mobilesafari',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _rateMyApp.init();
      print('shouldOpenDialog: ${_rateMyApp.shouldOpenDialog}');

      if (mounted && _rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          ignoreNativeDialog: true,
          //Platform.isAndroid,
          title: LocaleKeys.enjoyingMobileApp.tr(),
          message: LocaleKeys.tapAStarToRateItOnTheAppStore.tr(),
          starRatingOptions: StarRatingOptions(
            glow: false,
            minRating: 1,
            itemSize: 30,
            initialRating: 4,
            allowHalfRating: true,
            glowColor: AppColor.blueLight,
            itemColor: AppColor.blueLight,
            borderColor: AppColor.blueLight,
            borderColorChecked: AppColor.blueLight,
          ),
          actionsBuilder: (context, stars) {
            return [
              // RateMyAppRateButton(instance, text: 'OK'),
              // RateMyAppLaterButton(_rateMyApp, text: LocaleKeys.notNow.tr()),

              Text(
                'OK',
                style: AppTextStyle.w400.modifier(
                  fontSize: 17,
                  color: AppColor.blueLight,
                ),
              ).buttonize(
                splashType: SplashType.noSplash,
                onTap: () async {
                  _rateMyApp.launchStore();
                  await _rateMyApp.callEvent(
                    RateMyAppEventType.rateButtonPressed,
                  );
                  Navigator.pop<RateMyAppDialogButton>(
                    context,
                    RateMyAppDialogButton.rate,
                  );
                },
              ),

              Text(
                LocaleKeys.notNow.tr(),
                style: AppTextStyle.w400.modifier(
                  fontSize: 17,
                  color: AppColor.blueLight,
                ),
              ).buttonize(
                splashType: SplashType.noSplash,
                onTap: () async {
                  await _rateMyApp.callEvent(
                    RateMyAppEventType.laterButtonPressed,
                  );
                  Navigator.pop<RateMyAppDialogButton>(
                    context,
                    RateMyAppDialogButton.later,
                  );
                },
              ),
            ];
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            _AppBar(_textEditingController),
            _BodyView(_scrollController),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
