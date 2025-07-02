part of '../home_page.dart';

class _AppBar extends StatelessWidget {
  final TextEditingController _textEditingController;

  const _AppBar(this._textEditingController);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      stretch: true,
      alwaysShowMiddle: false,
      middle: Text('PixelScan'),
      largeTitle: AppAsset.logo.displayImage(width: 150, height: 34),
      bottomMode: NavigationBarBottomMode.always,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: AnimatedBuilder(
            animation: _textEditingController,
            builder: (context, _) {
              return CupertinoSearchTextField(
                itemSize: 24,
                prefixIcon: SizedBox.shrink(),
                backgroundColor: AppColor.white,
                controller: _textEditingController,
                placeholder: LocaleKeys.search.tr(),
                prefixInsets: EdgeInsetsGeometry.zero,
                suffixMode: OverlayVisibilityMode.always,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                suffixInsets: const EdgeInsetsDirectional.fromSTEB(
                  0,
                  14,
                  22,
                  14,
                ),
                style: AppTextStyle.w500.modifier(fontSize: 17),
                placeholderStyle: AppTextStyle.w400.modifier(
                  fontSize: 17,
                  color: AppColor.lowLight,
                ),
                suffixIcon: Icon(
                  _textEditingController.value.text.isEmpty
                      ? CupertinoIcons.search
                      : CupertinoIcons.xmark,
                  color: AppColor.text,
                ),
                onSuffixTap: () {
                  if (_textEditingController.value.text.isNotEmpty) {
                    _textEditingController.clear();
                  }
                },
                onChanged: (value) {
                  context.read<ScannerBloc>().add(ScannerEvent.search(value));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
