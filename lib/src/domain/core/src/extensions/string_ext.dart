extension NullableStringExtension on String? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    }
    final isEmpty = this!.replaceAll(' ', '').isEmpty;
    return isEmpty;
  }
}

extension StringExt on String {
  String get needsToBeTranslated => this;
}
