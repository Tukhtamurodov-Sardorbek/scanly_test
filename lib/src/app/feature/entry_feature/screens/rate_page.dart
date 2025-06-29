import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:scanly_test/generated/locale_keys.g.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/feature/entry_feature/components/entry_button.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';

@RoutePage()
class RatePage extends StatefulWidget implements AutoRouteWrapper {
  const RatePage({super.key});

  @override
  State<RatePage> createState() => _RatePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return RateMyAppBuilder(
        rateMyApp: RateMyApp(
          googlePlayIdentifier: 'com.android.chrome',
          appStoreIdentifier: 'com.apple.mobilesafari',

        ),
        onInitialized: (context, instance){},
        builder: (context){
          return this;
        },
    );
  }
}

class _RatePageState extends State<RatePage> {
  // late final InAppReview _appReview;

  @override
  void initState() {
    super.initState();
    // _appReview = InAppReview.instance;
    // Future.microtask(() async {
    //   final result = await _appReview.isAvailable();
    //   if (result) {
    //     _appReview.requestReview();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 38,
              right: 0,
              height: 310,
              child: AppAsset.backgroundSquares.displayImage(),
            ),
            Positioned(
              left: 26,
              top: 38,
              right: 26,
              bottom: 38,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8.h,
                          children: [
                            _Indicator(),
                            _Indicator(),
                            _Indicator(true),
                            _Indicator(),
                          ],
                        ),
                        20.horizontalSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.rateUs.tr(),
                              style: AppTextStyle.w600.modifier(
                                fontSize: 36,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocaleKeys.helpUsImproveWithYourFeedback.tr(),
                                maxLines: 4,
                                style: AppTextStyle.w400.modifier(
                                  fontSize: 20,
                                  color: AppColor.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  22.verticalSpace,
                  AppAsset.onboardImage2.displayImage(fit: BoxFit.cover),
                  const Spacer(),
                  EntryButton(
                    onTap: () {
                      GetAppNavigator.mainNavigator().navigateToMainPage(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isActive;

  const _Indicator([this.isActive = false]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 5.w,
      height: isActive ? 32.h : 12.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isActive
              ? AppColor.primaryTone
              : AppColor.lightGrey,
          borderRadius: BorderRadius.circular(88),
        ),
      ),
    );
  }
}
