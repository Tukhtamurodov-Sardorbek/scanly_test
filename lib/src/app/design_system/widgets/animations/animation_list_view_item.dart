import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HorizontalAnimationItemWrapper extends StatelessWidget {
  final Widget child;
  final int position;
  final int milliseconds;

  const HorizontalAnimationItemWrapper({
    super.key,
    required this.child,
    required this.position,
    this.milliseconds = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.fastLinearToSlowEaseIn,
        horizontalOffset: 80.0,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: milliseconds),
          child: child,
        ),
      ),
    );
  }
}

class VerticalAnimationItemWrapper extends StatelessWidget {
  final Widget child;
  final int position;
  final int milliseconds;


  const VerticalAnimationItemWrapper({
    super.key,
    required this.child,
    required this.position,
    this.milliseconds = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: position,
      duration: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.fastLinearToSlowEaseIn,
        verticalOffset: 80.0,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: milliseconds),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedGridWrapper extends StatelessWidget {
  final Widget child;
  final int position;
  final int columnCount;
  final int milliseconds;

  const AnimatedGridWrapper({
    super.key,
    required this.child,
    required this.position,
    required this.columnCount,
    this.milliseconds = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: position,
      duration: const Duration(milliseconds: 300),
      columnCount: columnCount,
      child: SlideAnimation(
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.fastLinearToSlowEaseIn,
        verticalOffset: 50.0,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: milliseconds),
          child: child,
        ),
      ),
    );
  }
}
