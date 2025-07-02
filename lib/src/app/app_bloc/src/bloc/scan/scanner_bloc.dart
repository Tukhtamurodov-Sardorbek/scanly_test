import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

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
        onDeleted: (group) => _onDeleted(group, emit),
        onExpanded: (group) => _onExpanded(group, emit),
        onScanOverwritten: (bts, im, th, gr) =>
            _onScanOverwritten(bts, im, th, gr, emit),
      );
    });
  }

  Future<void> _retrieveAllGroups(Emitter<ScannerState> emit) async {
    final data = await _scanner.getAllGroups();
    _data = List.from(data);
    type = SortType.latestFirst;
    if (_data.isEmpty) {
      emit(ScannerState.loadedEmpty());
    } else {
      emit(ScannerState.loaded(_data, type));
    }
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
        groupDir.path,
      );

      final paths = await _scanner.movePicturesFromCacheToPersistentStorage(
        cachedPicturesPath,
        groupDir.path,
      );

      final group = ScanGroup.newGroup(
        imagesPath: paths,
        creationTime: now,
        thumbnailPath: thumbnailPath ?? paths.first,
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
    if (copy.isEmpty) {
      emit(ScannerState.loadedEmpty());
    } else {
      emit(ScannerState.loaded(List.from(copy), type));
    }
  }

  void _onSearch(_SearchGroup event, Emitter<ScannerState> emit) {
    final lowerQuery = event.query.toLowerCase();

    List<MapEntry<ScanGroup, int>> filtered = [];

    for (int index = 0; index < _data.length; index++) {
      final group = _data[index];
      final title = (group.title ?? '${LocaleKeys.document.tr()} ${group.id}')
          .toLowerCase();
      final matchIndex = title.indexOf(lowerQuery!);
      if (matchIndex >= 0) {
        filtered.add(MapEntry(group, matchIndex));
      }
    }
    filtered.sort((a, b) => a.value.compareTo(b.value));
    final result = List<ScanGroup>.from(filtered.map((e) => e.key));

    if (result.isEmpty) {
      emit(ScannerState.loadedEmpty());
    } else {
      emit(ScannerState.loaded(result, SortType.latestFirst));
    }
  }

  Future<void> _onRenamed(ScanGroup group, Emitter<ScannerState> emit) async {
    final count = await _scanner.updateGroup(group);
    await _retrieveAllGroups(emit);
  }

  Future<void> _onDeleted(ScanGroup group, Emitter<ScannerState> emit) async {
    final count = await _scanner.deleteGroup(group.id);
    await _retrieveAllGroups(emit);
  }

  Future<void> _onExpanded(ScanGroup group, Emitter<ScannerState> emit) async {
    final cachedPicturesPath = await _scanner.scan;

    if (cachedPicturesPath != null && cachedPicturesPath.isNotEmpty) {
      emit(ScannerState.loading());
      final list = group.imagesPath;
      final directory = File(group.imagesPath.first).parent;
      final paths = await _scanner.movePicturesFromCacheToPersistentStorage(
        cachedPicturesPath,
        directory.path,
      );
      list.addAll(paths);
      await _scanner.updateGroup(group.copyWith(imagesPath: List.from(list)));
      await _retrieveAllGroups(emit);
    }
  }

  Future<void> _onScanOverwritten(
    Uint8List editedImageBytes,
    String path,
    String? thumbnailPath,
    ScanGroup group,
    Emitter<ScannerState> emit,
  ) async {
    emit(ScannerState.loading());
    // final isDone = await _scanner.overwriteImage(editedImageBytes, path);
    // String thumb = '-';
    // if (thumbnailPath != null) {
    //   thumb = await _thumbnailer.overwrite(path, thumbnailPath);
    // }
    // if (isDone) {
    //   await _retrieveAllGroups(emit);
    // }

    String? thumb;
    List<String> list = group.imagesPath;
    final index = list.indexOf(path);
    final newPath = await _scanner.overwriteImage(editedImageBytes, path);
    if (newPath == null) {
      await _retrieveAllGroups(emit);
      return;
    }
    if (thumbnailPath != null) {
      thumb = await _thumbnailer.replace(newPath, thumbnailPath);
    }
    if (index != -1) {
      list[index] = newPath;
    }
    await _scanner.updateGroup(
      group.copyWith(thumbnailPath: thumb, imagesPath: List.from(list)),
    );
    await _retrieveAllGroups(emit);

    /*
    List<String> list = group.imagesPath;
    final index = list.indexOf(path);

    String? thumb, newPath;
    if (thumbnailPath != null) {
      final record = await _scanner
          .overwriteImage(editedImageBytes, path, canDelete: false)
          .zipWith(_thumbnailer.replace(path, thumbnailPath));
      newPath = record.$1;
      thumb = record.$2;
    } else {
      newPath = await _scanner.overwriteImage(
        editedImageBytes,
        path,
        canDelete: thumbnailPath == null,
      );
    }

    if (newPath != null && index != -1) {
      list[index] = newPath;
    }
    _scanner.updateGroup(
      group.copyWith(thumbnailPath: thumb, imagesPath: List.from(list)),
    );
    await _retrieveAllGroups(emit);
     */
  }
}
