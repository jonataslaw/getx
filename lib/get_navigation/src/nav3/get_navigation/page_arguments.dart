import 'package:flutter/widgets.dart';

extension PageArgExt on BuildContext {
  RouteSettings? get settings {
    return ModalRoute.of(this)!.settings;
  }

  PageSettings? get pageSettings {
    final args = ModalRoute.of(this)?.settings.arguments;
    if (args is PageSettings) {
      return args;
    }
    return null;
  }

  dynamic get arguments {
    final args = settings?.arguments;
    if (args is PageSettings) {
      return args.arguments;
    } else {
      return args;
    }
  }

  Map<String, String> get params {
    final args = settings?.arguments;
    if (args is PageSettings) {
      return args.params;
    } else {
      return {};
    }
  }

  Router get router {
    return Router.of(this);
  }

  String get location {
    final parser = router.routeInformationParser;
    final config = delegate.currentConfiguration;
    return parser?.restoreRouteInformation(config)?.location ?? '/';
  }

  RouterDelegate get delegate {
    return router.routerDelegate;
  }
}

class PageSettings extends RouteSettings {
  PageSettings(
    this.uri, [
    this.arguments,
  ]);

  @override
  String get name => '$uri';

  @override
  late final Object? arguments;

  final Uri uri;

  final params = <String, String>{};

  String get path => uri.path;

  List<String> get paths => uri.pathSegments;

  Map<String, String> get query => uri.queryParameters;

  Map<String, List<String>> get queries => uri.queryParametersAll;

  @override
  String toString() => name;

  PageSettings copy({
    Uri? uri,
    Object? arguments,
  }) {
    return PageSettings(
      uri ?? this.uri,
      arguments ?? this.arguments,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageSettings &&
        other.uri == uri &&
        other.arguments == arguments;
  }

  @override
  int get hashCode => uri.hashCode ^ arguments.hashCode;
}
