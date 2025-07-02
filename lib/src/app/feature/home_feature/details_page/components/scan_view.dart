part of '../details_page.dart';

class _ScanView extends StatelessWidget {
  final BoxConstraints constraints;

  const _ScanView(this.constraints);

  @override
  Widget build(BuildContext context) {
    final reference = DetailsPage.of(context);
    return ValueListenableBuilder(
      valueListenable: reference._activeIndex,
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
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                final isIncrement = value > reference._oldIndex;
                final inAnimation = Tween<Offset>(
                  begin: isIncrement ? Offset(1.0, 0.0) : Offset(-1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation);
                final outAnimation = Tween<Offset>(
                  begin: isIncrement ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation);

                if (child.key == ValueKey(value)) {
                  return FadeTransition(
                    opacity: animation,
                    child: ClipRect(
                      child: SlideTransition(
                        position: inAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.all(8.0),
                          child: child,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Image.file(
                File(reference.widget.group.imagesPath[value]),
                key: ValueKey(value),
                fit: BoxFit.scaleDown,
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.9,
              ),
            ),

            Text(
              '${LocaleKeys.page.tr()} ${LocaleKeys.smthOFsmth.tr(args: [(value + 1).toString(), reference.widget.group.imagesPath.length.toString()])}',
            ),
          ],
        );
      },
    );
  }
}
