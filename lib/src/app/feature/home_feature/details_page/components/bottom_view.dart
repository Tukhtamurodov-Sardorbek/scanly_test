part of '../details_page.dart';

class _BottomView extends StatelessWidget {
  const _BottomView({super.key});

  @override
  Widget build(BuildContext context) {
    final reference = DetailsPage.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            spreadRadius: 0,
            offset: Offset(0, 0),
            color: AppColor.whiteShadow2_8,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          34,
          18,
          34,
          ScreenUtil().bottomBarHeight + 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAsset.edit.displayImage(height: 24, width: 24),
                4.verticalSpace,
                Text(
                  LocaleKeys.edit.tr(),
                  style: AppTextStyle.w400.modifier(
                    fontSize: 15,
                    color: AppColor.textQuaternary,
                  ),
                ),
              ],
            ).buttonize(
              onTap: () {
                final index = reference._activeIndex.value;
                final path = reference.widget.group.imagesPath[index];
                GetAppNavigator.mainNavigator().navigateToEditorPage(
                  imagePath: path,
                  group: reference.widget.group,
                  thumbnailPath: index == 0
                      ? reference.widget.group.thumbnailPath
                      : null,
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAsset.add.displayImage(height: 24, width: 24),
                4.verticalSpace,
                Text(
                  LocaleKeys.add.tr(),
                  style: AppTextStyle.w400.modifier(
                    fontSize: 15,
                    color: AppColor.textQuaternary,
                  ),
                ),
              ],
            ).buttonize(
              onTap: () {
                context.read<ScannerBloc>().add(
                  ScannerEvent.expandGroup(reference.widget.group),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
