import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/design_system/widgets/animations/animation_effect.dart';
import 'package:scanly_test/src/app/design_system/widgets/animations/animation_list_view_item.dart';

enum SplashType {
  noSplash(NoSplash.splashFactory),
  defaultSplash(InkSplash.splashFactory),
  straightSplash(InkSparkle.splashFactory),
  aggressiveSplash(InkRipple.splashFactory);

  const SplashType(this.factory);

  final InteractiveInkFeatureFactory factory;
}

extension WidgetExt on Widget {
  Widget buttonize({
    required VoidCallback? onTap,
    bool withBouncingAnimation = false,
    BorderRadius? borderRadius,
    SplashType? splashType,
    REdgeInsets? padding,
    Color? highlightColor,
    Color? splashColor,
    Color? backgroundColor,
    Decoration? decoration,
  }) {
    if (onTap == null) {
      return this;
    }
    if (withBouncingAnimation) {
      return AnimationButtonEffect(onTap: onTap, child: this);
    }
    final defaultColor = splashType == SplashType.noSplash
        ? Colors.transparent
        : null;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashFactory: splashType?.factory,
        splashColor: defaultColor ?? splashColor,
        highlightColor: defaultColor ?? highlightColor,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(12)),
        child: Ink(
          padding: padding,
          decoration:
              decoration ??
              BoxDecoration(
                color: backgroundColor ?? Colors.transparent,
                borderRadius:
                    borderRadius ?? BorderRadius.all(Radius.circular(12)),
              ),
          child: this,
        ),
      ),
    );
  }

  Widget wrapWithVerticalAnimation({int index = 0, int milliseconds = 1000}) {
    return VerticalAnimationItemWrapper(
      position: index,
      milliseconds: milliseconds,
      child: this,
    );
  }

  Widget verticalAnimationWrapper({int index = 0, int milliseconds = 680}) {
    return VerticalAnimationItemWrapper(
      position: index,
      milliseconds: milliseconds,
      child: this,
    );
  }

  Widget wrapWithDownToUpAnimation({
    Key? key,
    required double delayFactor,
    bool withPosition = true,
    bool reversePosition = false,
    Function()? onFinish,
    bool applyOpacityAnimation = true,
  }) {
    return DownToUp(
      key: key,
      onFinish: onFinish,
      reversePosition: reversePosition,
      delayFactor: delayFactor,
      applyOpacityAnimation: applyOpacityAnimation,
      child: this,
    );
  }

  Widget wrapWith(Widget Function(Widget child) wrap) {
    return wrap(this);
  }

  Widget conditionalWrapper({
    required bool condition,
    required Widget Function(Widget child) wrapper,
  }) {
    return condition ? wrapper(this) : this;
  }
}
