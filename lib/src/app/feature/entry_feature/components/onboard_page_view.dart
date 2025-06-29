part of '../screens/onboard_page.dart';

class _OnboardPageView extends StatelessWidget {
  const _OnboardPageView();

  @override
  Widget build(BuildContext context) {
    final reference = OnboardPage.of(context);
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IndicatorView(),
              20.horizontalSpace,
              ValueListenableBuilder(
                valueListenable: reference.currentIndex,
                builder: (context, currentIndex, child) {
                  return _TitleView(currentIndex);
                },
              ),
            ],
          ),
        ).wrapWithDownToUpAnimation(delayFactor: 0.3),
        22.verticalSpace,
        ValueListenableBuilder(
          valueListenable: reference.currentIndex,
          builder: (context, currentIndex, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: reference.transition,
              child: currentIndex == 0
                  ? AppAsset.onboardImage1.displayImage(
                      key: ValueKey(reference.pageKey(0)),
                      fit: BoxFit.cover,
                    )
                  : AppAsset.onboardImage2.displayImage(
                      key: ValueKey(reference.pageKey(1)),
                      fit: BoxFit.cover,
                    ),
            );
          },
        ).wrapWithDownToUpAnimation(delayFactor: 0.4),
        const Spacer(),
        EntryButton(
          onTap: () {
            final value = reference.currentIndex.value;
            if (value == 0) {
              reference.currentIndex.value = 1;
            } else {
              GetAppNavigator.mainNavigator().navigateToMainPage(context);
            }
          },
        ).wrapWithDownToUpAnimation(delayFactor: 0.5),
      ],
    );
  }
}

class _TitleView extends StatelessWidget {
  final int index;

  const _TitleView(this.index);

  @override
  Widget build(BuildContext context) {
    final reference = OnboardPage.of(context);
    final title = index == 0 ? LocaleKeys.pdfScanner : LocaleKeys.rateUs;
    final subtitle = index == 0
        ? LocaleKeys.easilyScanDocumentsOrConvertThemToPdf
        : LocaleKeys.helpUsImproveWithYourFeedback;

    return AnimatedSwitcher(
      transitionBuilder: reference.transition,
      duration: const Duration(milliseconds: 200),
      child: Column(
        key: ValueKey(reference.pageKey(index)),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.tr(), style: AppTextStyle.w600.modifier(fontSize: 36)),
          Flexible(
            child: Text(
              subtitle.tr(),
              maxLines: 4,
              style: AppTextStyle.w400.modifier(
                fontSize: 20,
                color: AppColor.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
