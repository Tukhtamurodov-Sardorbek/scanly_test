import 'package:flutter/material.dart';

abstract class EntryNavigator{
  Future<void> navigateRatePage(BuildContext context);
  Future<void> navigateOnboardingPage(BuildContext context);
}
