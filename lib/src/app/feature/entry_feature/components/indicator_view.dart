part of '../screens/onboard_page.dart';

class _IndicatorView extends StatelessWidget {
  const _IndicatorView();

  @override
  Widget build(BuildContext context) {
    final currentIndex = OnboardPage.of(context).currentIndex;
    return AnimatedBuilder(
      animation: currentIndex,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.h,
          children: [
            _Indicator(currentIndex.value == 0),
            _Indicator(),
            _Indicator(currentIndex.value == 1),
            _Indicator(),
          ],
        );
      },
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isActive;

  const _Indicator([this.isActive = false]);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 5.w,
      height: isActive ? 32.h : 12.h,
      decoration: BoxDecoration(
        color: isActive ? AppColor.primaryTone : AppColor.lightGrey,
        borderRadius: BorderRadius.circular(88),
      ),
    );
  }
}
