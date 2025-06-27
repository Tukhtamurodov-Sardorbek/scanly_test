import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scanly_test/generated/locale_keys.g.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  static List<Widget> get view {
    return [
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAsset.logo
                .displayImage(width: 150)
                .wrapWithDownToUpAnimation(delayFactor: 0.5),
            24.verticalSpace,
            AnimatedTypingDots(
              localeKey: LocaleKeys.oneMomentPleaseWait,
            ).wrapWithDownToUpAnimation(delayFactor: 0.64),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: view));
  }
}
