import 'dart:async' show Completer;
import 'dart:io';

import 'package:flutter/cupertino.dart'
    show
        CupertinoTextField,
        OverlayVisibilityMode,
        CupertinoButton,
        CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:share_plus/share_plus.dart';

Future<T?> openCupertinoBottomSheet<T>({
  required BuildContext context,
  BoxConstraints? constraints,
  required Widget Function(BuildContext context, Color? backgroundColor)
  builder,
  ShapeBorder? shape,
  bool expand = false,
  double elevation = 0,
  Color? backgroundColor,
  bool enableDrag = true,
  bool isDismissible = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  double? closeProgressThreshold,
  Clip clipBehavior = Clip.hardEdge,
  Color barrierColor = Colors.black54,
  bool maintainBottomViewPadding = false,
  SystemUiOverlayStyle? overlayStyleCupertino,
  AnimationController? transitionAnimationController,
  BorderRadius borderRadius = const BorderRadius.vertical(
    top: Radius.circular(DesignConstants.defaultButtonHeight),
  ),
}) {
  return showCupertinoModalBottomSheet<T>(
    expand: expand,
    context: context,
    elevation: elevation,
    enableDrag: enableDrag,
    settings: routeSettings,
    barrierColor: barrierColor,
    clipBehavior: clipBehavior,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    overlayStyle: overlayStyleCupertino,
    secondAnimation: transitionAnimationController,
    closeProgressThreshold: closeProgressThreshold,
    backgroundColor: backgroundColor ?? AppColor.primaryBackground,
    shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
    builder: (BuildContext sheetContext) {
      return AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor:
              backgroundColor ?? AppColor.primaryBackground,
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          maintainBottomViewPadding: maintainBottomViewPadding,
          child: Material(
            type: MaterialType.transparency,
            child: builder(sheetContext, backgroundColor),
          ),
        ),
      ).conditionalWrapper(
        condition: constraints != null,
        wrapper: (child) {
          return ConstrainedBox(constraints: constraints!, child: child);
        },
      );
    },
  );
}

class BottomSheetTopDivider extends StatelessWidget {
  const BottomSheetTopDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 23.h,
      child: Center(
        child: Container(
          width: 40.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: AppColor.lowGrey,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ),
    );
  }
}

class AppPdfBottomSheetContent extends StatefulWidget {
  final String pdf;
  final ScanGroup group;
  final PdfAction action;
  final Color? backgroundColors;

  const AppPdfBottomSheetContent(
    this.pdf,
    this.group,
    this.action, {
    super.key,
    this.backgroundColors,
  });

  @override
  State<AppPdfBottomSheetContent> createState() =>
      _AppPdfBottomSheetContentState();
}

class _AppPdfBottomSheetContentState extends State<AppPdfBottomSheetContent> {
  int? pages = 0;
  int? currentPage = 0;
  late final ValueNotifier<bool> _isAllRead;
  late final Completer<PDFViewController> _controller;

  @override
  void initState() {
    super.initState();
    _isAllRead = ValueNotifier(false);
    _controller = Completer<PDFViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.r,
          child: ColoredBox(
            color: widget.backgroundColors ?? AppColor.primaryBackground,
            child: Stack(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [BottomSheetTopDivider()],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8),
                    child: FittedBox(
                      child: Text(
                        widget.group.titleUI,
                        style: AppTextStyle.w500.modifier(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: AppAsset.xMark
                      .displayImage(height: 16, width: 16, color: AppColor.text)
                      .wrapWith(
                        (child) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: child,
                        ),
                      )
                      .buttonize(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PDFView(
            autoSpacing: false,
            filePath: widget.pdf,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: true,
            backgroundColor:
                widget.backgroundColors ?? AppColor.primaryBackground,
            onRender: (pagesNumber) {
              pages = pagesNumber;
            },
            onViewCreated: (PDFViewController controller) {
              _controller.complete(controller);
            },
            onPageChanged: (int? page, int? total) {
              currentPage = page;
              if (pages != null) {
                if (page == pages! - 1) {
                  _isAllRead.value = true;
                }
              }
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _isAllRead,
          builder: (context, read, _) {
            return FutureBuilder<PDFViewController>(
              future: _controller.future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: REdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          color: AppColor.primaryTone,
                          onPressed: () async {
                            var isSet = await snapshot.data!.setPage(
                              pages! - 1,
                            );
                            printSimple('Is scrolled to last page: $isSet');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22.0,
                            ).r,
                            child: Center(
                              child: Text(
                                LocaleKeys.scrollToTheEnd,
                                style: AppTextStyle.w500.modifier(
                                  fontSize: 17,
                                  color: AppColor.white,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                        8.verticalSpace,
                        CupertinoButton(
                          color: AppColor.primaryTone,
                          onPressed: () {
                            switch (widget.action) {
                              case PdfAction.print:
                                Printing.layoutPdf(
                                  name: widget.group.titleUI,
                                  onLayout: (PdfPageFormat format) async =>
                                      File(widget.pdf).readAsBytes(),
                                );
                              case PdfAction.share:
                                SharePlus.instance.share(
                                  ShareParams(
                                    text: widget.group.titleUI,
                                    files: [XFile(widget.pdf)],
                                    previewThumbnail: XFile(
                                      widget.group.thumbnailPath,
                                    ),
                                  ),
                                );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22.0,
                            ).r,
                            child: Center(
                              child: Text(
                                widget.action.isShare
                                    ? LocaleKeys.share
                                    : LocaleKeys.print,
                                style: AppTextStyle.w500.modifier(
                                  fontSize: 17,
                                  color: AppColor.white,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isAllRead.dispose();
    super.dispose();
  }
}

class RenameBottomsheetContent extends StatefulWidget {
  final ScanGroup group;

  const RenameBottomsheetContent({super.key, required this.group});

  @override
  State<RenameBottomsheetContent> createState() =>
      _RenameBottomsheetContentState();
}

class _RenameBottomsheetContentState extends State<RenameBottomsheetContent> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.group.titleUI);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadius.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 7,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_6,
          ),
          BoxShadow(
            offset: Offset(0, -13),
            blurRadius: 13,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_5,
          ),
          BoxShadow(
            offset: Offset(0, -30),
            blurRadius: 18,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_3,
          ),
          BoxShadow(
            offset: Offset(0, -53),
            blurRadius: 21,
            spreadRadius: 0,
            color: AppColor.whiteShadow1,
          ),
          BoxShadow(
            offset: Offset(0, -82),
            blurRadius: 23,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: bottomInset + 18,
          top: 18,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: AppAsset.xMark
                      .displayImage(height: 12, width: 12)
                      .buttonize(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                ),
                14.horizontalSpace,
                Text(
                  LocaleKeys.rename.tr(),
                  style: AppTextStyle.w500.modifier(fontSize: 19),
                ),
              ],
            ),
            24.verticalSpace,
            CupertinoTextField(
              controller: _ctrl,
              autofocus: true,
              clearButtonMode: OverlayVisibilityMode.never,
              style: AppTextStyle.w400.modifier(fontSize: 17),
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 22.0,
              ),
              decoration: BoxDecoration(
                color: AppColor.primaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.primaryTone, width: 1),
              ),
            ),
            24.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColor.primaryTone,
                      borderRadius: BorderRadius.circular(
                        DesignConstants.borderRadius,
                      ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.save.tr(),
                              style: AppTextStyle.w500.modifier(
                                fontSize: 17,
                                color: AppColor.white,
                              ),
                            ),
                            8.horizontalSpace,
                            Icon(
                              CupertinoIcons.checkmark_alt,
                              color: AppColor.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).buttonize(
                    withBouncingAnimation: true,
                    onTap: () {
                      final newName = _ctrl.text.trim();
                      if (newName.isNotEmpty) {
                        context.read<ScannerBloc>().add(
                          ScannerEvent.renameGroup(
                            widget.group.copyWith(title: newName),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        /// TODO: Show a warning dialog
                        printWarning('New name cannot be empty');
                        Navigator.pop(context);
                      }
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class LanguagesBottomsheetContent extends StatefulWidget {
  const LanguagesBottomsheetContent({super.key});

  @override
  State<LanguagesBottomsheetContent> createState() =>
      _LanguagesBottomsheetContentState();
}

class _LanguagesBottomsheetContentState
    extends State<LanguagesBottomsheetContent> {
  late final ValueNotifier<int> _notifier;
  late final List<AppLocale> _locales;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(0);
    _locales = AppLocale.values;
    final shortKey = LocaleKeys.localeShortKey.tr().toLowerCase();
    for (int index = 0; index < _locales.length; index++) {
      if (_locales[index].name.toLowerCase() == shortKey) {
        _notifier.value = index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadius.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 7,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_6,
          ),
          BoxShadow(
            offset: Offset(0, -13),
            blurRadius: 13,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_5,
          ),
          BoxShadow(
            offset: Offset(0, -30),
            blurRadius: 18,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_3,
          ),
          BoxShadow(
            offset: Offset(0, -53),
            blurRadius: 21,
            spreadRadius: 0,
            color: AppColor.whiteShadow1,
          ),
          BoxShadow(
            offset: Offset(0, -82),
            blurRadius: 23,
            spreadRadius: 0,
            color: AppColor.whiteShadow2_0,
          ),
        ],
      ),
      child: AnimationLimiter(
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          padding: EdgeInsets.all(18),
          child: ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, value, child) {
              return Column(
                children: List.generate(_locales.length, (index) {
                  final locale = _locales[index];
                  return RadioListTile.adaptive(
                    value: index,
                    groupValue: value,
                    fillColor: WidgetStateProperty.resolveWith<Color>((_) {
                      return AppColor.primaryTone;
                    }),
                    controlAffinity: ListTileControlAffinity.trailing,
                    tileColor: Colors.primaries[index],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0).h,
                    onChanged: (_) async {
                      final cachedContext = context;
                      Future.microtask(() async {
                        if (_notifier.value != index) {
                          _notifier.value = index;
                          cachedContext.setLocale(Locale(locale.name));
                          final engine =
                              WidgetsFlutterBinding.ensureInitialized();
                          await engine.performReassemble();
                        }
                      });
                      Future.delayed(
                        Duration(milliseconds: 280),
                        () => Navigator.pop(cachedContext),
                      );
                    },
                    title: Text(
                      locale.title.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.w500.modifier(fontSize: 16),
                    ),
                    secondary: Text(
                      locale.flag,
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ).verticalAnimationWrapper(
                    index: index + 1,
                    milliseconds: 470,
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
