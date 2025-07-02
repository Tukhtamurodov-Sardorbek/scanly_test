// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [DetailsPage]
class DetailsRoute extends PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    Key? key,
    required ScanGroup group,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
         DetailsRoute.name,
         args: DetailsRouteArgs(key: key, group: group, title: title),
         initialChildren: children,
       );

  static const String name = 'DetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailsRouteArgs>();
      return DetailsPage(key: args.key, group: args.group, title: args.title);
    },
  );
}

class DetailsRouteArgs {
  const DetailsRouteArgs({this.key, required this.group, required this.title});

  final Key? key;

  final ScanGroup group;

  final String title;

  @override
  String toString() {
    return 'DetailsRouteArgs{key: $key, group: $group, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailsRouteArgs) return false;
    return key == other.key && group == other.group && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ group.hashCode ^ title.hashCode;
}

/// generated route for
/// [EditorPage]
class EditorRoute extends PageRouteInfo<EditorRouteArgs> {
  EditorRoute({
    Key? key,
    required String path,
    required ScanGroup group,
    required String? thumbnailPath,
    List<PageRouteInfo>? children,
  }) : super(
         EditorRoute.name,
         args: EditorRouteArgs(
           key: key,
           path: path,
           group: group,
           thumbnailPath: thumbnailPath,
         ),
         initialChildren: children,
       );

  static const String name = 'EditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditorRouteArgs>();
      return EditorPage(
        key: args.key,
        path: args.path,
        group: args.group,
        thumbnailPath: args.thumbnailPath,
      );
    },
  );
}

class EditorRouteArgs {
  const EditorRouteArgs({
    this.key,
    required this.path,
    required this.group,
    required this.thumbnailPath,
  });

  final Key? key;

  final String path;

  final ScanGroup group;

  final String? thumbnailPath;

  @override
  String toString() {
    return 'EditorRouteArgs{key: $key, path: $path, group: $group, thumbnailPath: $thumbnailPath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditorRouteArgs) return false;
    return key == other.key &&
        path == other.path &&
        group == other.group &&
        thumbnailPath == other.thumbnailPath;
  }

  @override
  int get hashCode =>
      key.hashCode ^ path.hashCode ^ group.hashCode ^ thumbnailPath.hashCode;
}

/// generated route for
/// [EntryPagesWrapper]
class EntryRoutesWrapper extends PageRouteInfo<void> {
  const EntryRoutesWrapper({List<PageRouteInfo>? children})
    : super(EntryRoutesWrapper.name, initialChildren: children);

  static const String name = 'EntryRoutesWrapper';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const EntryPagesWrapper());
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [HomePageWrapper]
class HomeRouter extends PageRouteInfo<void> {
  const HomeRouter({List<PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const HomePageWrapper());
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const MainPage());
    },
  );
}

/// generated route for
/// [OnboardPage]
class OnboardRoute extends PageRouteInfo<void> {
  const OnboardRoute({List<PageRouteInfo>? children})
    : super(OnboardRoute.name, initialChildren: children);

  static const String name = 'OnboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardPage();
    },
  );
}

/// generated route for
/// [RatePage]
class RateRoute extends PageRouteInfo<void> {
  const RateRoute({List<PageRouteInfo>? children})
    : super(RateRoute.name, initialChildren: children);

  static const String name = 'RateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const RatePage());
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}
