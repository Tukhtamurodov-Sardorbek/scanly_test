part of '../details_page.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final reference = DetailsPage.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 56),
      child: Padding(
        padding: EdgeInsets.only(left: 18, top: 30, right: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(DesignConstants.borderRadius.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0,
                color: AppColor.whiteShadow6,
              ),
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 3,
                spreadRadius: 0,
                color: AppColor.whiteShadow5,
              ),
              BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 4,
                spreadRadius: 0,
                color: AppColor.whiteShadow3,
              ),
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 4,
                spreadRadius: 0,
                color: AppColor.whiteShadow1,
              ),
              BoxShadow(
                offset: Offset(0, 16),
                blurRadius: 5,
                spreadRadius: 0,
                color: AppColor.whiteShadow0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppAsset.arrowBack
                          .displayImage(height: 24, width: 24)
                          .buttonize(
                            splashType: SplashType.noSplash,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                      8.horizontalSpace,

                      Flexible(
                        child: ValueListenableBuilder(
                          valueListenable: reference._activeIndex,
                          builder: (context, value, child) {
                            return FittedBox(
                              child: RichText(
                                text: TextSpan(
                                  text: reference.widget.title,
                                  style: AppTextStyle.w500.modifier(
                                    fontSize: 19,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          ' | ${LocaleKeys.smthOFsmth.tr(args: [(value + 1).toString(), reference.widget.group.imagesPath.length.toString()])}',
                                      style: AppTextStyle.w400.modifier(
                                        fontSize: 17,
                                        color: AppColor.lowLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      8.horizontalSpace,
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      LocaleKeys.share.tr(),
                      style: AppTextStyle.w400.modifier(
                        fontSize: 17,
                        color: AppColor.primaryTone,
                      ),
                    ),
                    4.horizontalSpace,
                    AppAsset.share.displayImage(height: 24, width: 24),
                  ],
                ).buttonize(
                  withBouncingAnimation: true,
                  splashType: SplashType.noSplash,
                  onTap: () {
                    context.read<ScannerBloc>().add(
                      ScannerEvent.generatePdf(
                        reference.widget.group,
                        PdfAction.share,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
