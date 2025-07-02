import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/design_system/widgets/animations/animation_list_view_item.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:scanly_test/src/domain/core/core.dart';

part 'components/top_bar.dart';

part 'components/scan_view.dart';

part 'components/scan_pics_view.dart';

part 'components/bottom_view.dart';

@RoutePage()
class DetailsPage extends StatefulWidget {
  final String title;
  final ScanGroup group;

  const DetailsPage({super.key, required this.group, required this.title});

  @override
  State<DetailsPage> createState() => _DetailsPageState();

  static _DetailsPageState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_DetailsPageState>();
    assert(state != null, 'No DetailsPage ancestor found in the widget tree');
    return state!;
  }
}

class _DetailsPageState extends State<DetailsPage> {
  int _oldIndex = -1;
  late final ValueNotifier<int> _activeIndex;

  @override
  void initState() {
    super.initState();
    _activeIndex = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            return Column(
              children: [
                _TopBar(),
                23.verticalSpace,
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return _ScanView(constraints);
                      },
                    ),
                  ),
                ),
                23.verticalSpace,
                _ScanPicsView(),
                23.verticalSpace,
              ],
            );
          },
        ),
        bottomNavigationBar: _BottomView(),
      ),
    );
  }

  @override
  void dispose() {
    _activeIndex.dispose();
    super.dispose();
  }
}
