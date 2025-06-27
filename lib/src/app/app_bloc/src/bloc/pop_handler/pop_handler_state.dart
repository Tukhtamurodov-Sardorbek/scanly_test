part of 'pop_handler_cubit.dart';

sealed class PopHandlerState extends Equatable {
  const PopHandlerState._();

  const factory PopHandlerState.initial() = _InitialState;

  const factory PopHandlerState.popRoute() = _PopRouteState;

  const factory PopHandlerState.keepRoute() = _KeepRouteState;

  T when<T>({
    required T Function() initial,
    required T Function() popRoute,
    required T Function() keepRoute,
  }) {
    return switch (this) {
      _InitialState() => initial(),
      _PopRouteState() => popRoute(),
      _KeepRouteState() => keepRoute(),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? popRoute,
    T Function()? keepRoute,
    required T Function() orElse,
  }) {
    return switch (this) {
      _InitialState() => initial?.call() ?? orElse(),
      _PopRouteState() => popRoute?.call() ?? orElse(),
      _KeepRouteState() => keepRoute?.call() ?? orElse(),
    };
  }
}

final class _InitialState extends PopHandlerState {
  const _InitialState() : super._();

  @override
  List<Object?> get props => [];
}

final class _PopRouteState extends PopHandlerState {
  const _PopRouteState() : super._();

  @override
  List<Object?> get props => [];
}

final class _KeepRouteState extends PopHandlerState {
  const _KeepRouteState() : super._();

  @override
  List<Object?> get props => [];
}
