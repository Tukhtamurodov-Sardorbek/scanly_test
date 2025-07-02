import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/design_system/widgets/loading_view.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';

@RoutePage()
class MainPage extends StatefulWidget implements AutoRouteWrapper {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  static _MainPageState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainPageState>();
    assert(state != null, 'No MainPage ancestor found in the widget tree');
    return state!;
  }
}

class _MainPageState extends State<MainPage> {
  late final ValueNotifier<bool> obscureScreen;

  @override
  void initState() {
    super.initState();
    obscureScreen = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          AutoTabsScaffold(
            homeIndex: 0,
            extendBody: true,
            routes: [GetAppRoute.homeRouter],
            bottomNavigationBuilder: (_, router) =>
                _BottomNavigationBar(router),
          ),
          ValueListenableBuilder(
            valueListenable: obscureScreen,
            builder: (context, show, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: show ? LoadingView.blur : SizedBox.shrink(),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: obscureScreen,
            builder: (context, show, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: show ? LoadingView.logo : SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    obscureScreen.dispose();
    super.dispose();
  }
}

class _BottomNavigationBar extends StatefulWidget {
  final TabsRouter tabsRouter;

  const _BottomNavigationBar(this.tabsRouter);

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  ScannerBloc? _scannerBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scannerBloc ??= context.read<ScannerBloc>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hideBar = widget.tabsRouter.topRoute.meta['fullScreen'] == true;
    return Visibility(
      visible: !hideBar,
      child: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight + 10),
        child: Stack(
          fit: StackFit.loose,
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 264,
              height: 68,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(88),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                      color: AppColor.whiteShadow2_8,
                    ),
                  ],
                ),
              ),
            ),

            AppAsset.scanButton
                .displayImage(height: 88.r)
                .buttonize(
                  withBouncingAnimation: true,
                  onTap: () {
                    _scannerBloc!.add(ScannerEvent.createNewGroup());
                  },
                ),
          ],
        ),
      ),
    );
  }
}
