// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.focusNode,
    super.controller,
    super.keyboardType,
    super.autofocus,
    super.readOnly,
    super.obscureText,
    super.obscuringCharacter,
    super.maxLines,
    String? labelText,
    super.onChanged,
    super.onTap,
    super.onEditingComplete,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    super.inputFormatters,
    super.enabled,
    super.selectionControls,
    super.enableSuggestions,
    super.autocorrect,
    Color? labelColor,
    Color? textColor,
    super.cursorColor,
    Widget? prefix,
    String? prefixText,
    Widget? prefixIcon,
    Widget? suffix,
    String? suffixText,
    Widget? suffixIcon,
    InputBorder? border,
    InputBorder? disabledBorder,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    InputBorder? errorBorder,
    AutovalidateMode? autoValidateMode,
    EdgeInsets? contentPadding,
    bool? isDense,
    super.textAlignVertical,
    super.textInputAction,
    String? hintText,
    BoxConstraints? suffixIconConstraints,
    BoxConstraints? prefixIconConstraints =
        const BoxConstraints(maxHeight: 24, maxWidth: 24),
    int errorMaxLines = 3,
    bool? filled,
    Color? fillColor,
    FloatingLabelBehavior? floatingLabelBehavior,
    String? helperText,
    super.maxLength,
    super.onTapOutside,
    TextStyle? style,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    TextStyle? prefixStyle,
    TextStyle? errorStyle,
    TextStyle? suffixStyle,
  }) : super(
          autovalidateMode: autoValidateMode,
          style: style ?? TextStyle(fontSize: 16.sp, color: textColor),
          decoration: InputDecoration(
            helperText: helperText,
            counterText: '',
            alignLabelWithHint: false,
            prefixIconConstraints: prefixIconConstraints,
            floatingLabelBehavior: floatingLabelBehavior,
            prefix: prefix,
            filled: filled,
            fillColor: fillColor,
            isDense: isDense,
            hintText: hintText,
            hintStyle: hintStyle ?? TextStyle(color: labelColor),
            contentPadding: contentPadding,
            labelText: labelText,
            labelStyle:
                labelStyle ?? TextStyle(color: labelColor, fontSize: 14.sp),
            floatingLabelStyle:
                floatingLabelStyle ?? TextStyle(color: labelColor),
            prefixText: prefixText,
            prefixIcon: prefixIcon,
            prefixStyle:
                prefixStyle ?? TextStyle(color: textColor, fontSize: 16.sp),
            errorStyle: errorStyle ?? const TextStyle(color: Colors.red),
            errorMaxLines: errorMaxLines,
            errorBorder: errorBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius.r),
                ),
            suffix: suffix,
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            suffixIconConstraints: suffixIconConstraints,
            suffixStyle:
                suffixStyle ?? TextStyle(color: textColor, fontSize: 16),
            border: border ??
                OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius),
                ),
            disabledBorder: disabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius.r),
                ),
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius.r),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius.r),
                ),
            focusedErrorBorder: focusedErrorBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                      BorderRadius.circular(DesignConstants.borderRadius.r),
                ),
          ),
        );
}
