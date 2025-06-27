import 'package:get_it/get_it.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';

mixin GetAppBloc {
  static EntryCubit entryCubit() => GetIt.I.get<EntryCubit>();

  static PopHandlerCubit popHandlerCubit() => GetIt.I.get<PopHandlerCubit>();

  static AppReviewCubit appReviewCubit() => GetIt.I.get<AppReviewCubit>();
}
