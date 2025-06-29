// import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/domain/usecase/usecase.dart';

@module
abstract class AppBlocModule {
  EntryCubit injectEntryCubit(EntryUsecase usecase) => EntryCubit(usecase);

  PopHandlerCubit injectPopHandlerCubit() => PopHandlerCubit();

  // AppReviewCubit provideAppReviewCubit() => AppReviewCubit(InAppReview.instance);

  ScannerBloc injectScannerBloc(
    ScannerUsecase scanner,
    ThumbnailUsecase thumbnailer,
  ) => ScannerBloc(scanner, thumbnailer);
}
