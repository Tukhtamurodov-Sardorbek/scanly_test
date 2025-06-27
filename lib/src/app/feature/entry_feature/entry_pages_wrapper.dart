import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/navigation/navigation.dart';

@RoutePage()
class EntryPagesWrapper extends AutoRouter implements AutoRouteWrapper {
  const EntryPagesWrapper({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy: false, create: (_) => GetAppBloc.entryCubit()),
        // BlocProvider(lazy: false, create: (_) => GetAppBloc.appReviewCubit()),
        BlocProvider(lazy: false, create: (_) => GetAppBloc.popHandlerCubit()),
      ],
      child: this,
    );
  }
}
