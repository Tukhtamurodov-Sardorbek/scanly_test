import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationTypeDownToUp { opacity, translateY }

class DownToUp extends StatelessWidget {
  final double delayFactor;
  final Widget child;
  final bool withPosition;
  final bool reversePosition;
  final Function()? onFinish;
  final bool applyOpacityAnimation;

  const DownToUp({
    super.key,
    required this.delayFactor,
    required this.child,
    this.withPosition = true,
    this.reversePosition = false,
    this.onFinish,
    this.applyOpacityAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final movie = MovieTween()
      ..tween(
        AnimationTypeDownToUp.translateY,
        Tween(begin: reversePosition ? -100.0 : 100.0, end: 0.0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutExpo,
      );
    if (applyOpacityAnimation) {
      movie.tween(
        AnimationTypeDownToUp.opacity,
        Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
      );
    }

    return PlayAnimationBuilder<Movie>(
      tween: movie,
      onCompleted: onFinish,
      duration: movie.duration,
      delay: Duration(milliseconds: (500 * delayFactor).round()),
      builder: (context, value, _) {
        return child
            .conditionalWrapper(
              condition: withPosition,
              wrapper: (child) {
                final offsetY = value.get(AnimationTypeDownToUp.translateY);
                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: child,
                );
              },
            )
            .conditionalWrapper(
              condition: applyOpacityAnimation,
              wrapper: (child) {
                final opacity = value.get(AnimationTypeDownToUp.opacity);
                return Opacity(opacity: opacity, child: child);
              },
            );
      },
      child: child,
    );
  }
}
