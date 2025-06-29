extension DateTimeFormatting on DateTime {
  String get toYYYYMMDD {
    String year = this.year.toString();
    String month = this.month.toString().padLeft(2, '0');
    String day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
