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
          padding: EdgeInsets.only(left: 12, top: 12, bottom: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.file(
                        File(widget.group.thumbnailPath),
                        width: 64,
                        // key: ValueKey(widget.group.thumbnailPath),
                      ),
                      16.horizontalSpace,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Note, the default title must be as the same as
                            /// written in _onSearch method of [ScannerBloc]
                            Flexible(
                              child: Text(
                                widget.group.titleUI,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.w500.modifier(fontSize: 17),
                              ),
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: AppAsset.menu
                      .displayImage(height: 26.r, width: 26.r)
                      .buttonize(
                        splashType: SplashType.noSplash,
                        onTap: _onMenuTap,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).buttonize(
      onTap: () {
        GetAppNavigator.mainNavigator().navigateToDetailsPage(
          group: widget.group,
          title: widget.group.titleUI,
        );
      },
    );
  }

  void _onMenuTap() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: null,
        message: null,
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              final cached = context;
              Navigator.pop(context);
              openCupertinoBottomSheet(
                context: cached,
                enableDrag: false,
                expand: false,
                backgroundColor: AppColor.primaryBackground,
                builder: (_, clr) =>
                    RenameBottomsheetContent(group: widget.group),
              );
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
              final bloc = context.read<ScannerBloc>();
              Navigator.pop(context);
              bloc.add(ScannerEvent.generatePdf(widget.group, PdfAction.print));
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
              final bloc = context.read<ScannerBloc>();
              Navigator.pop(context);
              bloc.add(ScannerEvent.generatePdf(widget.group, PdfAction.share));
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
              final bloc = context.read<ScannerBloc>();
              Navigator.pop(context);
              bloc.add(ScannerEvent.deleteGroup(widget.group));
            },
            child: Text(
              LocaleKeys.delete.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true, // Makes it bold
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.cancel.tr(),
            style: TextStyle(fontSize: 20, color: CupertinoColors.systemBlue),
          ),
        ),
      ),
    );
  }
}
