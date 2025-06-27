import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainPageWrapper extends AutoRouter implements AutoRouteWrapper {
  const MainPageWrapper({super.key});

  static const routeName = '/';

  @override
  Widget wrappedRoute(BuildContext context) {
    // TODO: Provide all necessary blocs
    return Container(
      child: this,
    );
  }
}
