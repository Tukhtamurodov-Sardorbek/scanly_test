part of 'scanner_bloc.dart';

sealed class ScannerState extends Equatable {
  const ScannerState._();

  const factory ScannerState.init() = _Initial;

  const factory ScannerState.loading() = _Loading;

  const factory ScannerState.loaded(List<ScanGroup> data, SortType type) =
      _Loaded;

  const factory ScannerState.loadedEmpty() = _LoadedEmpty;

  T when<T>({
    required T Function() init,
    required T Function() loading,
    required T Function() loadedEmpty,
    required T Function(List<ScanGroup>, SortType type) loaded,
  }) {
    return switch (this) {
      _Initial() => init(),
      _Loading() => loading(),
      _LoadedEmpty() => loadedEmpty(),
      _Loaded(:final data, :final type) => loaded(data, type),
    };
  }

  T? whenOrNull<T>({
    T Function()? init,
    T Function()? loading,
    T Function()? loadedEmpty,
    T Function(List<ScanGroup>, SortType type)? loaded,
  }) {
    return switch (this) {
      _Initial() => init?.call(),
      _Loading() => loading?.call(),
      _LoadedEmpty() => loadedEmpty?.call(),
      _Loaded(:final data, :final type) => loaded?.call(data, type),
    };
  }

  T maybeWhen<T>({
    T Function()? init,
    T Function()? loading,
    T Function()? loadedEmpty,
    T Function(List<ScanGroup>, SortType type)? loaded,
    required T Function() orElse,
  }) {
    return whenOrNull(
          init: init,
          loaded: loaded,
          loading: loading,
          loadedEmpty: loadedEmpty,
        ) ??
        orElse();
  }
}

final class _Initial extends ScannerState {
  const _Initial() : super._();

  @override
  List<Object> get props => [];
}

final class _Loading extends ScannerState {
  const _Loading() : super._();

  @override
  List<Object> get props => [];
}

final class _Loaded extends ScannerState {
  final SortType type;
  final List<ScanGroup> data;

  const _Loaded(this.data, this.type) : super._();

  @override
  List<Object> get props => [data, type];

  @override
  String toString() {
    return 'LoadedState';
  }
}

final class _LoadedEmpty extends ScannerState {
  const _LoadedEmpty() : super._();

  @override
  List<Object> get props => [];
}
