import 'package:flutter/cupertino.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

class SliverAdapter extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const SliverAdapter({super.key, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: child.conditionalWrapper(
        condition: padding != null,
        wrapper: (view) {
          return Padding(padding: padding!, child: view);
        },
      ),
    );
  }
}
