import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/design_system/assets/app_asset.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBackground,
      body: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            stretch: true,
            alwaysShowMiddle: false,
            middle: Text('PixelScan'),
            largeTitle: AppAsset.logo.displayImage(width: 150, height: 34),
            bottomMode: NavigationBarBottomMode.always,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                child: ValueListenableBuilder(
                  valueListenable: _textEditingController,
                  builder: (context, value, _) {
                    return CupertinoSearchTextField(
                      itemSize: 24,
                      prefixIcon: SizedBox.shrink(),
                      backgroundColor: AppColor.of(context).appropriate,
                      controller: _textEditingController,
                      prefixInsets: EdgeInsetsGeometry.zero,
                      suffixMode: OverlayVisibilityMode.always,
                      placeholder: 'Search...'.needsToBeTranslated,
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
                      style: AppTextStyle.w500.modifier(
                        fontSize: 17,
                        isDark: context.isDark,
                      ),
                      placeholderStyle: AppTextStyle.w400.modifier(
                        isDark: context.isDark,
                        fontSize: 17,
                        color: AppColor.lowLight,
                      ),
                      suffixIcon: Icon(
                        value.text.isEmpty
                            ? CupertinoIcons.search
                            : CupertinoIcons.xmark,
                        color: AppColor.light.text,
                      ),
                      onSuffixTap: () {
                        if (value.text.isNotEmpty) {
                          _textEditingController.clear();
                        }
                      },
                      onChanged: (_) {
                        print('LOOK: ${value.runtimeType}');
                        print('LOOK: ${value}');
                        print('LOOK: ${value.text}');
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0).r,
            sliver: DecoratedSliver(
              decoration: BoxDecoration(
                color: AppColor.of(context).appropriate,
                borderRadius: BorderRadius.circular(
                  DesignConstants.borderRadius,
                ),
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
              sliver: SliverPadding(
                padding: const EdgeInsets.all(16.0).r,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    return ListTile(title: Text('Item #$index'));
                  }, childCount: 50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
