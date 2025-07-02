import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'HomeRouter')
class HomePageWrapper extends AutoRouter implements AutoRouteWrapper {
  const HomePageWrapper({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
