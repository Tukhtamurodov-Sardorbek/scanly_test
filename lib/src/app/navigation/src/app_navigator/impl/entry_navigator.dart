import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';

class EntryNavigatorImpl extends EntryNavigator {
  EntryNavigatorImpl();

  @override
  Future<void> navigateRatePage(BuildContext context) {
    return context.router.replace(const RateRoute());
  }

  @override
  Future<void> navigateOnboardingPage(BuildContext context) {
    return context.router.replace(const OnboardRoute());
  }
}
