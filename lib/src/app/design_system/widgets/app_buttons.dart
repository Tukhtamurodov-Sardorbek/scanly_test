// import 'package:flutter/material.dart';
// import 'package:scanly_test/src/app/design_system/design_system.dart';
//
// class PrimaryButton extends TextButton {
//   PrimaryButton({
//     super.key,
//     required bool isDark,
//     required super.child,
//     required super.onPressed,
//     EdgeInsetsGeometry? padding,
//     double? maxWidth,
//     double? minHeight,
//   }) : super(
//          style: ButtonStyle(
//            minimumSize: WidgetStatePropertyAll(
//              Size(
//                maxWidth ?? DesignConstants.buttonMaxWidth.r,
//                minHeight ?? DesignConstants.defaultButtonHeight.r,
//              ),
//            ),
//            maximumSize: WidgetStatePropertyAll(
//              Size(
//                maxWidth ?? DesignConstants.buttonMaxWidth.r,
//                double.infinity,
//              ),
//            ),
//            foregroundColor: const WidgetStatePropertyAll(AppColor.white),
//            backgroundColor: WidgetStateProperty.resolveWith<Color>((
//              Set<WidgetState> states,
//            ) {
//              if (states.contains(WidgetState.disabled)) {
//                /// TODO: return disabled button color
//              }
//              return isDark
//                  ? AppColor.dark.primaryTone
//                  : AppColor.light.primaryTone;
//            }),
//            overlayColor: MaterialStateProperty.resolveWith<Color>((
//              Set<WidgetState> states,
//            ) {
//              return Colors.white12;
//            }),
//            padding: WidgetStatePropertyAll(
//              padding ??
//                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13).r,
//            ),
//            shape: WidgetStatePropertyAll(
//              RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(
//                  DesignConstants.borderRadius,
//                ),
//              ),
//            ),
//          ),
//        );
// }
