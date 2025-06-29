import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart' show restartable;
import 'package:equatable/equatable.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:scanly_test/src/domain/usecase/src/scanner_usecase.dart';
import 'package:scanly_test/src/domain/usecase/src/thumbnail_usecase.dart';

import '../../../../../domain/core/core.dart';

part 'scanner_event.dart';

part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final ScannerUsecase _scanner;
  final ThumbnailUsecase _thumbnailer;
  SortType type = SortType.latestFirst;
  List<ScanGroup> _data = [];

  ScannerBloc(this._scanner, this._thumbnailer) : super(ScannerState.init()) {
    on<_SortGroup>(_onSorted);
    on<_SearchGroup>(_onSearch, transformer: restartable());
    on<ScannerEvent>((event, emit) async {
      await event.whenOrNull(
        onRetrieveAllGroups: () => _retrieveAllGroups(emit),
        onNewGroupCreated: () => _onNewGroupCreated(emit),
        onRenamed: (group) => _onRenamed(group, emit),
      );
    });
  }

  Future<void> _retrieveAllGroups(Emitter<ScannerState> emit) async {
    final data = await _scanner.getAllGroups();
    _data = List.from(data);
    type = SortType.latestFirst;
    emit(ScannerState.loaded(data, type));
  }

  Future<void> _onNewGroupCreated(Emitter<ScannerState> emit) async {
    final cachedPicturesPath = await _scanner.scan;

    if (cachedPicturesPath != null && cachedPicturesPath.isNotEmpty) {
      emit(ScannerState.loading());

      final now = DateTime.now();
      final iso8601 = now.toIso8601String();
      final groupDir = await _scanner.createGroupDirectory(iso8601);

      final thumbnailPath = await _thumbnailer.generate(
        cachedPicturesPath.first,
        directoryPath: groupDir.path,
      );

      final paths = await _scanner.movePicturesFromCacheToPersistentStorage(
        cachedPicturesPath,
        groupDir.path,
      );

      final group = ScanGroup.newGroup(
        imagesPath: paths,
        creationTime: now,
        thumbnailPath: thumbnailPath,
      );

      await _scanner.saveGroup(group);
      await _retrieveAllGroups(emit);
    }
  }

  FutureOr<void> _onSorted(_SortGroup event, Emitter<ScannerState> emit) {
    final copy = state.maybeWhen(
      loaded: (data, _) => data,
      orElse: () => _data,
    );
    if (event.type.isLatestFirst) {
      copy.sort((a, b) => b.creationTime.compareTo(a.creationTime));
    } else {
      copy.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    }

    type = event.type;
    emit(ScannerState.loaded(List.from(copy), type));
  }

  void _onSearch(_SearchGroup event, Emitter<ScannerState> emit) {
    final lowerQuery = event.query.toLowerCase();
    List<MapEntry<ScanGroup, int>> filtered = [];

    for (int index = 0; index < _data.length; index++) {
      final group = _data[index];
      final title = (group.title ?? '${LocaleKeys.document.tr()} ${index + 1}')
          .toLowerCase();
      final matchIndex = title.indexOf(lowerQuery);
      if (matchIndex >= 0) {
        filtered.add(MapEntry(group, matchIndex));
      }
    }

    filtered.sort((a, b) => a.value.compareTo(b.value));
    final result = List<ScanGroup>.from(filtered.map((e) => e.key));
    emit(ScannerState.loaded(result, SortType.latestFirst));
  }

  Future<void> _onRenamed(ScanGroup group, Emitter<ScannerState> emit) async {
    print('>>> $group');
    final count = await _scanner.updateGroup(group);
    await _retrieveAllGroups(emit);
    print('>>> $_data');
  }
}
