import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/generated/locale_keys.g.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/design_system/widgets/loading_view.dart';
import 'package:scanly_test/src/app/feature/entry_feature/components/entry_button.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';

part '../components/indicator_view.dart';

part '../components/onboard_page_view.dart';

@RoutePage()
class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();

  // Static method to access the state from descendant widgets
  static _OnboardPageState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_OnboardPageState>();
    assert(state != null, 'No OnboardPage ancestor found in the widget tree');
    return state!;
  }
}

class _OnboardPageState extends State<OnboardPage> {
  late final ValueNotifier<int> currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = ValueNotifier<int>(0);
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
              child: _OnboardPageView(),
            ),
          ],
        ),
      ),
    );
  }

  String pageKey(int index) => 'page_$index';

  Widget transition(Widget child, Animation<double> animation) {
    final inAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(animation);
    final outAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(animation);

    if (child.key == ValueKey(pageKey(1))) {
      return FadeTransition(
        opacity: animation,
        child: ClipRect(
          child: SlideTransition(
            position: inAnimation,
            child: Padding(padding: const EdgeInsets.all(8.0), child: child),
          ),
        ),
      );
    } else {
      return FadeTransition(
        opacity: animation,
        child: ClipRect(
          child: SlideTransition(
            position: outAnimation,
            child: Padding(padding: const EdgeInsets.all(8.0), child: child),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    currentIndex.dispose();
    super.dispose();
  }
}
