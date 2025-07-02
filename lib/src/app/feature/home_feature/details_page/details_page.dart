import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';
import 'package:scanly_test/src/domain/model/model.dart';

import '../../../../domain/core/core.dart';

@RoutePage()
class DetailsPage extends StatefulWidget {
  final String title;
  final ScanGroup group;

  const DetailsPage({super.key, required this.group, required this.title});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final ValueNotifier<int> _activeIndex;
  int _oldIndex = -1;

  @override
  void initState() {
    super.initState();
    _activeIndex = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    ScanGroup group = widget.group;
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 56),
                  child: Padding(
                    padding: EdgeInsets.only(left: 18, top: 30, right: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(
                          DesignConstants.borderRadius.r,
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

                                  ValueListenableBuilder(
                                    valueListenable: _activeIndex,
                                    builder: (context, value, child) {
                                      return RichText(
                                        text: TextSpan(
                                          text: widget.title,
                                          style: AppTextStyle.w500.modifier(
                                            fontSize: 19,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  ' | ${LocaleKeys.smthOFsmth.tr(args: [(value + 1).toString(), widget.group.imagesPath.length.toString()])}',
                                              style: AppTextStyle.w400.modifier(
                                                fontSize: 17,
                                                color: AppColor.lowLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
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
                                AppAsset.share.displayImage(
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            ).buttonize(onTap: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                23.verticalSpace,
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ValueListenableBuilder(
                          valueListenable: _activeIndex,
                          builder: (context, value, child) {
                            // final imageFile = File(
                            //   widget.group.imagesPath[value],
                            // );
                            // WidgetsBinding.instance.addPostFrameCallback((
                            //   _,
                            // ) async {
                            //   imageCache.clear();
                            //   imageCache.evict(FileImage(imageFile));
                            //
                            //   setState(() {});
                            // });
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  layoutBuilder:
                                      (currentChild, previousChildren) {
                                        return Stack(
                                          alignment: Alignment.topCenter,
                                          children: <Widget>[
                                            ...previousChildren,
                                            if (currentChild != null)
                                              currentChild,
                                          ],
                                        );
                                      },
                                  transitionBuilder: (child, animation) {
                                    final isIncrement = value > _oldIndex;
                                    final inAnimation = Tween<Offset>(
                                      begin: isIncrement
                                          ? Offset(1.0, 0.0)
                                          : Offset(-1.0, 0.0),
                                      end: Offset(0.0, 0.0),
                                    ).animate(animation);
                                    final outAnimation = Tween<Offset>(
                                      begin: isIncrement
                                          ? Offset(-1.0, 0.0)
                                          : Offset(1.0, 0.0),
                                      end: Offset(0.0, 0.0),
                                    ).animate(animation);

                                    if (child.key == ValueKey(value)) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ClipRect(
                                          child: SlideTransition(
                                            position: inAnimation,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ClipRect(
                                          child: SlideTransition(
                                            position: outAnimation,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: child,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.file(
                                    File(widget.group.imagesPath[value]),
                                    key: ValueKey(value),
                                    fit: BoxFit.scaleDown,
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight * 0.9,
                                  ),
                                ),

                                Text(
                                  '${LocaleKeys.page.tr()} ${LocaleKeys.smthOFsmth.tr(args: [(value + 1).toString(), widget.group.imagesPath.length.toString()])}',
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                23.verticalSpace,
                SizedBox(
                  height: 67,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    itemCount: widget.group.imagesPath.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        child: ValueListenableBuilder(
                          valueListenable: _activeIndex,
                          builder: (context, value, child) {
                            // final imageFile = File(
                            //   widget.group.imagesPath[index],
                            // );
                            // WidgetsBinding.instance.addPostFrameCallback((
                            //   _,
                            // ) async {
                            //   if (index == 0) {
                            //     imageCache.clear();
                            //     imageCache.evict(FileImage(imageFile));
                            //
                            //     setState(() {});
                            //   }
                            // });
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                border: value == index
                                    ? Border.all(color: AppColor.primaryTone)
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Image.file(
                                    File(widget.group.imagesPath[index]),
                                    // key: ValueKey(value),
                                  ),
                                ),
                              ),
                            ).buttonize(
                              withBouncingAnimation: true,
                              onTap: () {
                                _oldIndex = _activeIndex.value;
                                _activeIndex.value = index;
                              },
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 12.horizontalSpace;
                    },
                  ),
                ),
                23.verticalSpace,
              ],
            );
          },
        ),
        bottomNavigationBar: DecoratedBox(
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
                    final index = _activeIndex.value;
                    final path = widget.group.imagesPath[index];
                    GetAppNavigator.mainNavigator().navigateToEditorPage(
                      imagePath: path,
                      group: widget.group,
                      thumbnailPath: index == 0
                          ? widget.group.thumbnailPath
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
                      ScannerEvent.expandGroup(widget.group),
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

  @override
  void dispose() {
    _activeIndex.dispose();
    super.dispose();
  }
}
