part of '../home_page.dart';

class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250),
            child: AppAsset.nothing.displayImage(fit: BoxFit.cover),
          ),
        ),
        Text(
          LocaleKeys.noDocumentFound.tr(),
          style: AppTextStyle.w500.modifier(fontSize: 19),
        ),
        16.verticalSpace,
        Text(
          LocaleKeys.tapTheButtonBellowToScanOrConvertToPDF.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.w400.modifier(
            fontSize: 15,
            color: AppColor.textTertiary,
          ),
        ),
      ],
    );
  }
}
