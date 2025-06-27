import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/services.dart';

extension ContextExt on BuildContext {
  bool get isDark {
    final isDarkMode = Theme.of(this).brightness == Brightness.dark;
    return isDarkMode;
  }

  SystemUiOverlayStyle getSystemUiOverlayStyle() {
    final SystemUiOverlayStyle systemOverlayStyle;
    switch (Theme.of(this).brightness) {
      case Brightness.dark:
        systemOverlayStyle = SystemUiOverlayStyle.light;
        break;
      case Brightness.light:
        systemOverlayStyle = SystemUiOverlayStyle.dark;
        break;
    }
    return systemOverlayStyle.copyWith(
      systemNavigationBarColor: Colors.transparent,
    );
  }

  void runAfterBuild(
    void Function(BuildContext context) callback, {
    int? delayInMilliseconds,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (delayInMilliseconds != null && delayInMilliseconds > 0) {
        Future.delayed(Duration(milliseconds: delayInMilliseconds), () {
          if (mounted) callback(this);
        });
      } else {
        callback(this);
      }
    });
  }
}
