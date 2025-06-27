import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

class AnimatedTypingDots extends StatefulWidget {
  final int maxDots;
  final String localeKey;
  final TextStyle? textStyle;

  const AnimatedTypingDots({
    super.key,
    this.textStyle,
    this.maxDots = 3,
    required this.localeKey,
  });

  @override
  State<AnimatedTypingDots> createState() => _AnimatedTypingDotsState();
}

class _AnimatedTypingDotsState extends State<AnimatedTypingDots>
    with SingleTickerProviderStateMixin {
  int _visibleDotCount = 0;
  late final AnimationController _controller;

  @override
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(_updateDots);
    _controller.repeat();
  }

  void _updateDots() {
    final newCount = (_controller.value * (widget.maxDots + 1)).floor();
    if (newCount != _visibleDotCount) {
      setState(() {
        _visibleDotCount = newCount % (widget.maxDots + 1);
      });
    }
  }

  TextStyle get _effectiveStyle {
    return widget.textStyle ??
        AppTextStyle.w500.modifier(fontSize: 19, isDark: context.isDark);
  }

  @override
  Widget build(BuildContext context) {
    final style = _effectiveStyle;
    final transparentStyle = style.copyWith(color: Colors.transparent);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: widget.localeKey.tr()),
          for (int i = 0; i < widget.maxDots; i++)
            TextSpan(
              text: '.',
              style: i < _visibleDotCount ? style : transparentStyle,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
