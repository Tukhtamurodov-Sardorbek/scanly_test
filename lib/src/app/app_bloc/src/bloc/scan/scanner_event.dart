part of 'scanner_bloc.dart';

sealed class ScannerEvent extends Equatable {
  const ScannerEvent._();

  const factory ScannerEvent.retrieveAllGroups() = _RetrieveAllGroups;

  const factory ScannerEvent.createNewGroup() = _CreateNewGroup;

  const factory ScannerEvent.sort(SortType type) = _SortGroup;

  const factory ScannerEvent.search(String query) = _SearchGroup;

  const factory ScannerEvent.renameGroup(ScanGroup group) = _RenameGroup;

  const factory ScannerEvent.deleteGroup(ScanGroup group) = _DeleteGroup;

  const factory ScannerEvent.expandGroup(ScanGroup group) = _ExpandGroup;

  const factory ScannerEvent.overwriteScan({
    required Uint8List editedImageBytes,
    required String path,
    required ScanGroup group,
    String? thumbnailPath,
  }) = _EditPicture;

  T when<T>({
    required T Function() onNewGroupCreated,
    required T Function() onRetrieveAllGroups,
    required T Function(String query) onSearch,
    required T Function(SortType type) onSorted,
    required T Function(ScanGroup group) onRenamed,
    required T Function(ScanGroup group) onDeleted,
    required T Function(ScanGroup group) onExpanded,
    required T Function(
      Uint8List editedImageBytes,
      String path,
      String? thumbnailPath,
      ScanGroup group,
    )
    onScanOverwritten,
  }) {
    return switch (this) {
      _CreateNewGroup() => onNewGroupCreated(),
      _RetrieveAllGroups() => onRetrieveAllGroups(),
      _SearchGroup(:final query) => onSearch(query),
      _SortGroup(:final type) => onSorted(type),
      _RenameGroup(:final group) => onRenamed(group),
      _DeleteGroup(:final group) => onDeleted(group),
      _ExpandGroup(:final group) => onExpanded(group),
      _EditPicture(
        :final editedImageBytes,
        :final path,
        :final thumbnailPath,
        :final group,
      ) =>
        onScanOverwritten(editedImageBytes, path, thumbnailPath, group),
    };
  }

  T? whenOrNull<T>({
    T Function()? onNewGroupCreated,
    T Function()? onRetrieveAllGroups,
    T Function(String query)? onSearch,
    T Function(SortType type)? onSorted,
    T Function(ScanGroup group)? onRenamed,
    T Function(ScanGroup group)? onDeleted,
    T Function(ScanGroup group)? onExpanded,
    T Function(
      Uint8List editedImageBytes,
      String path,
      String? thumbnailPath,
      ScanGroup group,
    )?
    onScanOverwritten,
  }) {
    return switch (this) {
      _CreateNewGroup() => onNewGroupCreated?.call(),
      _RetrieveAllGroups() => onRetrieveAllGroups?.call(),
      _SearchGroup(:final query) => onSearch?.call(query),
      _SortGroup(:final type) => onSorted?.call(type),
      _RenameGroup(:final group) => onRenamed?.call(group),
      _DeleteGroup(:final group) => onDeleted?.call(group),
      _ExpandGroup(:final group) => onExpanded?.call(group),
      _EditPicture(
        :final editedImageBytes,
        :final path,
        :final thumbnailPath,
        :final group,
      ) =>
        onScanOverwritten?.call(editedImageBytes, path, thumbnailPath, group),
    };
  }
}

final class _RetrieveAllGroups extends ScannerEvent {
  const _RetrieveAllGroups() : super._();

  @override
  List<Object?> get props => [];
}

final class _CreateNewGroup extends ScannerEvent {
  const _CreateNewGroup() : super._();

  @override
  List<Object?> get props => [];
}

final class _SortGroup extends ScannerEvent {
  final SortType type;

  const _SortGroup(this.type) : super._();

  @override
  List<Object?> get props => [type];
}

final class _SearchGroup extends ScannerEvent {
  final String query;

  const _SearchGroup(this.query) : super._();

  @override
  List<Object?> get props => [query];
}

final class _RenameGroup extends ScannerEvent {
  final ScanGroup group;

  const _RenameGroup(this.group) : super._();

  @override
  List<Object?> get props => [group];
}

final class _EditPicture extends ScannerEvent {
  final Uint8List editedImageBytes;
  final String path;
  final String? thumbnailPath;
  final ScanGroup group;

  const _EditPicture({
    required this.editedImageBytes,
    required this.path,
    required this.group,
    this.thumbnailPath,
  }) : super._();

  @override
  List<Object?> get props => [editedImageBytes, path, thumbnailPath, group];
}

final class _DeleteGroup extends ScannerEvent {
  final ScanGroup group;

  const _DeleteGroup(this.group) : super._();

  @override
  List<Object?> get props => [group];
}

final class _ExpandGroup extends ScannerEvent {
  final ScanGroup group;

  const _ExpandGroup(this.group) : super._();

  @override
  List<Object?> get props => [group];
}
