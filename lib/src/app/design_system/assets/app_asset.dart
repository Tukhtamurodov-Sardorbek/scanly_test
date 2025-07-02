enum AssetType { png, svg }

final class AppAsset {
  AppAsset._();

  static const String _base = 'assets/images';

  static String get arrow => '$_base/arrow.png';

  static String get arrowBack => '$_base/arrow_back.png';

  static String get backgroundSquares => '$_base/background_squares.png';

  static String get logo => '$_base/logo.png';

  static String get menu => '$_base/menu.png';

  static String get nothing => '$_base/nothing.png';

  static String get onboardImage1 => '$_base/onboard_image1.png';

  static String get onboardImage2 => '$_base/onboard_image2.png';

  static String get scanButton => '$_base/scan_button.png';

  static String get search => '$_base/search.png';

  static String get sorted => '$_base/sorted.png';

  static String get unsorted => '$_base/unsorted.png';

  static String get xMark => '$_base/x_mark.png';

  static String get share => '$_base/share.png';

  static String get edit => '$_base/edit.png';

  static String get add => '$_base/add.png';
}
