part of '../home_page.dart';

class _ListTile extends StatefulWidget {
  final ScanGroup group;

  const _ListTile(this.group);

  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  @override
  Widget build(BuildContext context) {
    // final imageFile = File(widget.group.thumbnailPath);
    final title =
        widget.group.title ?? '${LocaleKeys.document.tr()} ${widget.group.id}';
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   imageCache.clear();
    //   imageCache.evict(FileImage(imageFile));
    //
    //   setState(() {});
    // });
    return SizedBox(
      height: 88.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColor.primaryBackground,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.file(
                      File(widget.group.thumbnailPath),
                      width: 64,
                      // key: ValueKey(widget.group.thumbnailPath),
                    ),
                    16.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Note, the default title must be as the same as
                        /// written in _onSearch method of [ScannerBloc]
                        Text(
                          title,
                          style: AppTextStyle.w500.modifier(fontSize: 17),
                        ),
                        Flexible(
                          child: Text(
                            '${widget.group.imagesPath.length} | ${widget.group.creationTime.toYYYYMMDD}',
                            style: AppTextStyle.w400.modifier(
                              fontSize: 16,
                              color: AppColor.lowLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppAsset.menu
                  .displayImage(height: 26.r, width: 26.r)
                  .buttonize(
                    splashType: SplashType.noSplash,
                    onTap: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: null,
                          message: null,
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              onPressed: () {
                                print('Rename tapped!');
                                _showRenameDialog(context, widget.group);
                              },
                              child: Text(
                                LocaleKeys.rename.tr(),
                                style: AppTextStyle.w400.modifier(
                                  fontSize: 20,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                print('Print tapped!');
                              },
                              child: Text(
                                LocaleKeys.print.tr(),
                                style: AppTextStyle.w400.modifier(
                                  fontSize: 20,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                print('Share tapped!');
                              },
                              child: Text(
                                LocaleKeys.share.tr(),
                                style: AppTextStyle.w400.modifier(
                                  fontSize: 20,
                                  color: CupertinoColors.systemBlue,
                                ),
                              ),
                            ),

                            CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                print('Delete tapped!');

                                context.read<ScannerBloc>().add(
                                  ScannerEvent.deleteGroup(widget.group),
                                );
                              },
                              child: Text(
                                LocaleKeys.delete.tr(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true, // Makes it bold
                            onPressed: () {
                              print('Cancel tapped!');
                              Navigator.pop(context);
                            },
                            child: Text(
                              LocaleKeys.cancel.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    ).buttonize(
      onTap: () {
        GetAppNavigator.mainNavigator().navigateToDetailsPage(
          title: title,
          group: widget.group,
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, ScanGroup group) {
    final textCtrl = TextEditingController(
      text: group.title ?? '${LocaleKeys.document.tr()} ${widget.group.id}',
    );

    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: AppAsset.xMark
                    .displayImage(height: 10, width: 10)
                    .buttonize(
                      onTap: () {
                        context.pop();
                      },
                    ),
              ),
              8.horizontalSpace,
              Text(
                LocaleKeys.rename.tr(),
                style: AppTextStyle.w500.modifier(fontSize: 19),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              8.verticalSpace,
              CupertinoTextField(
                controller: textCtrl,
                autofocus: true,
                clearButtonMode: OverlayVisibilityMode.never,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: CupertinoColors.systemGrey4,
                    width: 0.5,
                  ),
                ),
                style: const TextStyle(color: CupertinoColors.black),
              ),
              const SizedBox(height: 16),

              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                color: CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(10),
                onPressed: () {
                  final newName = textCtrl.text.trim();
                  if (newName.isNotEmpty) {
                    context.read<ScannerBloc>().add(
                      ScannerEvent.renameGroup(group.copyWith(title: newName)),
                    );
                    Navigator.pop(context);
                  } else {
                    print('New name cannot be empty'.needsToBeTranslated);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.save.tr(),
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.checkmark_alt,
                      color: CupertinoColors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
