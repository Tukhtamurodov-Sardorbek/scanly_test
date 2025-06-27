import 'package:flutter/material.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/generated/locale_keys.g.dart';

enum AppLocale {
  it(flag: '🇮🇹', title: LocaleKeys.itLanguage, languageCode: 'it'),
  de(flag: '🇩🇪', title: LocaleKeys.deLanguage, languageCode: 'de'),
  ptBr(flag: '🇵🇹', title: LocaleKeys.ptLanguage, languageCode: 'pt'),
  es(flag: '🇪🇸', title: LocaleKeys.esLanguage, languageCode: 'es'),
  fr(flag: '🇫🇷', title: LocaleKeys.frLanguage, languageCode: 'fr'),
  ru(flag: '🇷🇺', title: LocaleKeys.ruLanguage, languageCode: 'ru'),
  en(flag: '🇬🇧', title: LocaleKeys.enLanguage, languageCode: 'en');

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
