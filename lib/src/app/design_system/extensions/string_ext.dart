import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension StringExt on String {
  Color get asColor {
    int length = this.length;
    int value = 0;

    for (int i = (startsWith('#') ? 1 : 0); i < length; i++) {
      int digit = codeUnitAt(i);
      if (digit >= 48 && digit <= 57) {
        value = (value << 4) + digit - 48;
      } else if (digit >= 65 && digit <= 70) {
        value = (value << 4) + digit - 55;
      } else if (digit >= 97 && digit <= 102) {
        value = (value << 4) + digit - 87;
      }
    }

    // If no alpha channel provided, add FF
    if (length - (startsWith('#') ? 1 : 0) == 6) {
      value |= 0xFF000000;
    }

    return Color(value);
  }

  Widget displayImage({
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    AlignmentGeometry? alignment,
  }) {
    return Image(
      key: key,
      fit: fit,
      color: color,
      width: width?.w,
      height: height?.h,
      alignment: alignment ?? Alignment.center,
      image: AssetImage(this),
    );
  }

  String get needsToBeTranslated => this;
}
