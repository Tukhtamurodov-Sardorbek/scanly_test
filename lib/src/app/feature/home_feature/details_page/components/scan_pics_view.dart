part of '../details_page.dart';

class _ScanPicsView extends StatelessWidget {
  const _ScanPicsView({super.key});

  @override
  Widget build(BuildContext context) {
    final reference = DetailsPage.of(context);
    return SizedBox(
      height: 67,
      child: AnimationLimiter(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 18),
          itemCount: reference.widget.group.imagesPath.length,
          itemBuilder: (context, index) {
            return ValueListenableBuilder(
              valueListenable: reference._activeIndex,
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
                        File(reference.widget.group.imagesPath[index]),
                        // key: ValueKey(value),
                      ),
                    ),
                  ),
                ).buttonize(
                  withBouncingAnimation: true,
                  onTap: () {
                    reference._oldIndex = reference._activeIndex.value;
                    reference._activeIndex.value = index;
                  },
                );
              },
            ).horizontalAnimationWrapper(index: index);
          },
          separatorBuilder: (context, index) {
            return 12.horizontalSpace;
          },
        ),
      ),
    );
  }
}
