import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

class MySliverAppBar extends SliverAppBar {
  MySliverAppBar(
    BuildContext context, {
    super.key,
    super.title,
    super.pinned = true,
    super.elevation = 6,
    super.snap = true,
    super.floating = true,
    SystemUiOverlayStyle? systemOverlayStyle,
    super.actions,
    super.leading,
    Color? backgroundColor,
    super.primary,
    super.bottom,
    super.expandedHeight,
    super.centerTitle = true,
    super.leadingWidth,
    super.automaticallyImplyLeading,
    super.shadowColor = AppColor.shadowColor,
    Widget? flexibleSpace,
  }) : super(
         backgroundColor:
             backgroundColor ?? AppColor.of(context).globalBackground,
         systemOverlayStyle:
             systemOverlayStyle ?? context.getSystemUiOverlayStyle(),
       );
}
