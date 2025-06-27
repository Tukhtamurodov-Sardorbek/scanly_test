import 'package:flutter/material.dart';

final class AppColor extends ThemeExtension<AppColor> {
  final Color primaryTone;
  final Color blueLight;
  final Color globalBackground;

  final Color? grey;
  final Color? text;
  final Color? contrast;
  final Color? appropriate;

  const AppColor._({
    required this.primaryTone,
    required this.blueLight,
    required this.globalBackground,
    this.grey,
    this.text,
    this.contrast,
    this.appropriate,
  });

  static AppColor get light {
    return const AppColor._(
      primaryTone: Color(0xFFFD1524),
      blueLight: Color(0xFF007AFF),
      globalBackground: Color(0xFFF7F7F7),
      grey: Color(0xFF8E8E93),
      text: Color(0xFF280609),
      contrast: Color(0xFF000000),
      appropriate: Color(0xFFFFFFFF),
    );
  }

  static AppColor get dark {
    return const AppColor._(
      primaryTone: Color(0xFFFF4C58),
      blueLight: Color(0xFF339CFF),
      globalBackground: Color(0xFF121212),
      grey: Color(0xFF5F5F5F),
      text: Color(0xFFFFFFFF),
      contrast: Color(0xFFFFFFFF),
      appropriate: Color(0xFF000000),
    );
  }

  static AppColor of(BuildContext context) =>
      Theme.of(context).extension<AppColor>()!;

  @override
  AppColor copyWith({
    Color? primaryTone,
    Color? blueLight,
    Color? globalBackground,
    Color? grey,
    Color? text,
    Color? contrast,
  }) {
    return AppColor._(
      primaryTone: primaryTone ?? this.primaryTone,
      blueLight: blueLight ?? this.blueLight,
      globalBackground: globalBackground ?? this.globalBackground,
      grey: grey ?? this.grey,
      text: text ?? this.text,
      contrast: contrast ?? this.contrast,
      appropriate: appropriate ?? this.appropriate,
    );
  }

  @override
  AppColor lerp(covariant ThemeExtension<AppColor>? other, double t) {
    if (other is! AppColor) return this;

    return AppColor._(
      primaryTone: Color.lerp(primaryTone, other.primaryTone, t)!,
      blueLight: Color.lerp(blueLight, other.blueLight, t)!,
      globalBackground: Color.lerp(
        globalBackground,
        other.globalBackground,
        t,
      )!,
      grey: Color.lerp(grey, other.grey, t),
      text: Color.lerp(text, other.text, t),
      contrast: Color.lerp(contrast, other.contrast, t),
      appropriate: Color.lerp(appropriate, other.appropriate, t),
    );
  }

  static const Color shadowColor = Color(0x4D000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGrey = Color(0xFFE8E5E5);
  static const Color secondaryText = Color(0xFF8B7979);
  static const Color lowLight = Color(0xFFCBCBCB);
  static const Color secondaryBackground = Color(0xFFF7F7F7);
  static const Color redShadow1 = Color(0x03C20F0F);
  static const Color redShadow11 = Color(0x1CC20F0F);
  static const Color redShadow36 = Color(0x5CC20F0F);
  static const Color redShadow61 = Color(0x9CC20F0F);
  static const Color redShadow71 = Color(0xB5C20F0F);

  static const Color whiteShadow0 = Color(0x363636);
  static const Color whiteShadow1 = Color(0x3363636);
  static const Color whiteShadow3 = Color(0x8363636);
  static const Color whiteShadow5 = Color(0xD363636);
  static const Color whiteShadow6 = Color(0xF363636);

}
