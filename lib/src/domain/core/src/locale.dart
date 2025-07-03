import 'package:flutter/material.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/generated/locale_keys.g.dart';

enum AppLocale {
  de(flag: '🇩🇪', title: LocaleKeys.deLanguage, languageCode: 'de'),
  en(flag: '🇬🇧', title: LocaleKeys.enLanguage, languageCode: 'en'),
  es(flag: '🇪🇸', title: LocaleKeys.esLanguage, languageCode: 'es'),
  fr(flag: '🇫🇷', title: LocaleKeys.frLanguage, languageCode: 'fr'),
  it(flag: '🇮🇹', title: LocaleKeys.itLanguage, languageCode: 'it'),
  pt(flag: '🇵🇹', title: LocaleKeys.ptLanguage, languageCode: 'pt'),
  ru(flag: '🇷🇺', title: LocaleKeys.ruLanguage, languageCode: 'ru');

  final String flag;
  final String title;
  final String languageCode;

  const AppLocale({
    required this.flag,
    required this.title,
    required this.languageCode,
  });
}

mixin AppLocaleConfig {
  static const String fallbackLocale = 'ru';
  static const String localePath = 'assets/translations';

  static AppLocale currentLocale(Locale locale) {
    final lang = locale.languageCode;
    final result = AppLocale.values.firstWhere(
      (element) => element.languageCode == lang,
    );
    return result;
  }
}
