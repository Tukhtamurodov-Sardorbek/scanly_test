part of '../home_page.dart';

class _BodyView extends StatefulWidget {
  final ScrollController scrollController;

  const _BodyView(this.scrollController);

  @override
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  SortType _sortType = SortType.latestFirst;

  void alterFilter() {
    context.read<ScannerBloc>().add(ScannerEvent.sort(_sortType.other));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerBloc, ScannerState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            MainPage.of(context).obscureScreen.value = true;
          },
          loaded: (_, _, pdf) {
            MainPage.of(context).obscureScreen.value = false;
            if (pdf != null) {
              openCupertinoBottomSheet(
                context: context,
                enableDrag: false,
                backgroundColor: AppColor.primaryBackground,
                constraints: BoxConstraints(maxHeight: 0.96.sh),
                builder: (_, color) => AppPdfBottomSheetContent(
                  pdf.path,
                  pdf.group,
                  pdf.action,
                  backgroundColors: color,
                ),
              );
            }
          },
        );
      },
      child: BlocBuilder<ScannerBloc, ScannerState>(
        buildWhen: (previous, current) {
          return current.when(
            init: () => true,
            loading: () => false,
            loadedEmpty: () => true,
            loaded: (_, type, _) {
              _sortType = type;
              return true;
            },
          );
        },
        builder: (context, state) {
          return SliverFillRemaining(
            hasScrollBody: state.maybeWhen(
              loaded: (_, _, _) => true,
              orElse: () => false,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocaleKeys.documents.tr(),
                            style: AppTextStyle.w500.modifier(fontSize: 21),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  transitionBuilder: (child, animation) {
                                    final curved = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.ease,
                                    );
                                    return FadeTransition(
                                      opacity: Tween(
                                        begin: 0.2,
                                        end: 1.0,
                                      ).animate(curved),
                                      child: ScaleTransition(
                                        scale: Tween(
                                          begin: 0.4,
                                          end: 1.0,
                                        ).animate(curved),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: state.maybeWhen(
                                    loaded: (data, type, _) {
                                      if (data.isEmpty) {
                                        return SizedBox.shrink();
                                      }

                                      return type.isLatestFirst
                                          ? AppAsset.unsorted
                                                .displayImage(
                                                  height: 34,
                                                  width: 34,
                                                )
                                                .buttonize(
                                                  key: ValueKey(
                                                    'unsorted_view',
                                                  ),
                                                  onTap: alterFilter,
                                        withBouncingAnimation: true,
                                                )
                                          : AppAsset.sorted
                                                .displayImage(
                                                  height: 34,
                                                  width: 34,
                                                )
                                                .buttonize(
                                                  key: ValueKey('sorted_view'),
                                                  onTap: alterFilter,
                                        withBouncingAnimation: true,
                                                );
                                    },
                                    orElse: () => SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: state.maybeWhen(
                            loaded: (data, _, _) {
                              return AnimationLimiter(
                                child: ListView.separated(
                                  itemCount: data.length,
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (_, _) => 14.verticalSpace,
                                  itemBuilder: (context, index) {
                                    return _ListTile(
                                      data[index],
                                    ).verticalAnimationWrapper(index: index);
                                  },
                                ),
                              );
                            },
                            orElse: () => _EmptyView(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
