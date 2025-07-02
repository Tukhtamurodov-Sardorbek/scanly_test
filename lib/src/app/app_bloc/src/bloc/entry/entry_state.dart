part of 'entry_cubit.dart';

sealed class EntryState extends Equatable {
  const EntryState._();

  const factory EntryState.initial() = _InitialState;

  const factory EntryState.notIntroduced() = _NotIntroducedState;

  const factory EntryState.introduced() = _IntroducedState;

  T when<T>({
    required T Function() initial,
    required T Function() notIntroduced,
    required T Function() introduced,
  }) {
    return switch (this) {
      _InitialState() => initial(),
      _NotIntroducedState() => notIntroduced(),
      _IntroducedState() => introduced(),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? notIntroduced,
    T Function()? introduced,
    required T Function() orElse,
  }) {
    return whenOrNull(
          initial: initial,
          introduced: introduced,
          notIntroduced: notIntroduced,
        ) ??
        orElse();
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? notIntroduced,
    T Function()? introduced,
  }) {
    return switch (this) {
      _InitialState() => initial?.call(),
      _NotIntroducedState() => notIntroduced?.call(),
      _IntroducedState() => introduced?.call(),
    };
  }
}

final class _InitialState extends EntryState {
  const _InitialState() : super._();

  @override
  List<Object?> get props => [];
}

final class _NotIntroducedState extends EntryState {
  const _NotIntroducedState() : super._();

  @override
  List<Object?> get props => [];
}

final class _IntroducedState extends EntryState {
  const _IntroducedState() : super._();

  @override
  List<Object?> get props => [];
}
