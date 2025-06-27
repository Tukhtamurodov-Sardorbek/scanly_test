import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';
import 'package:scanly_test/src/app/navigation/di/get.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      backgroundColor: AppColor.of(context).globalBackground,
      homeIndex: 0,
      routes: [GetAppRoute.homeRouter],
      bottomNavigationBuilder: (_, router) => _BottomNavigationBar(router),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final TabsRouter tabsRouter;

  const _BottomNavigationBar(this.tabsRouter);

  @override
  Widget build(BuildContext context) {
    final colors = AppColor.of(context);
    final hideBar = tabsRouter.topRoute.meta['fullScreen'] == true;
    return Visibility(
      visible: !hideBar,
      child: WillPopScope(
        onWillPop: () async {
          if (context.tabsRouter.activeIndex != tabsRouter.homeIndex) {
            if (tabsRouter.previousIndex != null) {
              tabsRouter.setActiveIndex(tabsRouter.homeIndex);
            }
            return false;
          }

          return true;
        },
        child: BottomNavigationBar(
          elevation: 0,
          enableFeedback: true,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          backgroundColor: colors.globalBackground,
          unselectedItemColor: colors.grey,
          selectedItemColor: colors.primaryTone,
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsRouter.activeIndex,
          onTap: (value) {
            if (value == tabsRouter.activeIndex &&
                tabsRouter.stackRouterOfIndex(value)?.canNavigateBack == true) {
              tabsRouter.stackRouterOfIndex(value)?.popUntilRoot();
            } else {
              tabsRouter.setActiveIndex(value);
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              backgroundColor: AppColor.white,
              icon: Icon(Icons.home, color: colors.grey),
              activeIcon: Icon(Icons.home, color: colors.primaryTone),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              backgroundColor: AppColor.white,
              icon: Icon(Icons.settings, color: colors.grey),
              activeIcon: Icon(Icons.settings, color: colors.primaryTone),
            ),
          ],
        ),
      ),
    );
  }
}
