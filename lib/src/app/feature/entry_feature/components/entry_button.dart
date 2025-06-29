import 'package:flutter/material.dart';

import '../../../../domain/core/core.dart';
import '../../../design_system/design_system.dart';

class EntryButton extends StatelessWidget {
  final void Function() onTap;

  const EntryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.primaryTone,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: AppColor.redShadow71,
          ),
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 3,
            spreadRadius: 0,
            color: AppColor.redShadow61,
          ),
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 5,
            spreadRadius: 0,
            color: AppColor.redShadow36,
          ),
          BoxShadow(
            offset: Offset(0, 13),
            blurRadius: 5,
            spreadRadius: 0,
            color: AppColor.redShadow11,
          ),
          BoxShadow(
            offset: Offset(0, 21),
            blurRadius: 6,
            spreadRadius: 0,
            color: AppColor.redShadow1,
          ),
        ],
      ),
      child: SizedBox(
        height: DesignConstants.defaultButtonHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.continue1.tr(),
                style: AppTextStyle.w500.modifier(
                  fontSize: 17,
                  color: AppColor.white,
                ),
              ),
              AppAsset.arrow.displayImage(width: 48),
            ],
          ),
        ),
      ),
    ).buttonize(onTap: onTap, withBouncingAnimation: true);
  }
}
