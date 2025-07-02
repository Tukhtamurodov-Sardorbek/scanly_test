import 'package:equatable/equatable.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/domain/usecase/src/entry_usecase.dart';

part 'entry_state.dart';

class EntryCubit extends Cubit<EntryState> {
  final EntryUsecase _usecase;

  EntryCubit(this._usecase) : super(EntryState.initial());

  Future<void> _updateRunTime() => _usecase.saveRunTimes();

  void check() {
    final times = _usecase.runTimes;
    if (times == 0) {
      emit(const EntryState.notIntroduced());
    } else {
      // final openRatePage = times == 1;
      emit(EntryState.introduced());
    }
    _updateRunTime();
    // _usecase.clearStorage();
  }
}
