import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../get.dart';

@immutable
class RouteDecoder {
  const RouteDecoder(
    this.currentTreeBranch,
    this.pageSettings, {
    this.restorationHistory,
  });
  final List<GetPage> currentTreeBranch;
  final PageSettings? pageSettings;

  /// The opt-in navigation snapshot transported by the route information parser.
  @internal
  final RestorableRouteHistory? restorationHistory;

  factory RouteDecoder.fromRoute(String location) {
    var uri = Uri.parse(location);
    final args = PageSettings(uri);
    final decoder =
        (Get.rootController.rootDelegate).matchRoute(location, arguments: args);
    decoder.route = decoder.route?.copyWith(
      completer: null,
      arguments: args,
      parameters: args.params,
    );
    return decoder;
  }

  GetPage? get route =>
      currentTreeBranch.isEmpty ? null : currentTreeBranch.last;

  GetPage routeOrUnknown(GetPage onUnknow) =>
      currentTreeBranch.isEmpty ? onUnknow : currentTreeBranch.last;

  set route(GetPage? getPage) {
    if (getPage == null) return;
    if (currentTreeBranch.isEmpty) {
      currentTreeBranch.add(getPage);
    } else {
      currentTreeBranch[currentTreeBranch.length - 1] = getPage;
    }
  }

  List<GetPage>? get currentChildren => route?.children;

  Map<String, String> get parameters => pageSettings?.params ?? {};

  dynamic get args {
    return pageSettings?.arguments;
  }

  T? arguments<T>() {
    final args = pageSettings?.arguments;
    if (args is T) {
      return pageSettings?.arguments as T;
    } else {
      return null;
    }
  }

  // void replaceArguments(Object? arguments) {
  //   final newRoute = route;
  //   if (newRoute != null) {
  //     final index = currentTreeBranch.indexOf(newRoute);
  //     currentTreeBranch[index] = newRoute.copyWith(arguments: arguments);
  //   }
  // }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteDecoder &&
        listEquals(other.currentTreeBranch, currentTreeBranch) &&
        other.pageSettings == pageSettings &&
        other.restorationHistory == restorationHistory;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(currentTreeBranch),
    pageSettings,
    restorationHistory,
  );

  @override
  String toString() =>
      'RouteDecoder(currentTreeBranch: $currentTreeBranch, pageSettings: $pageSettings)';
}

/// An internal, detached snapshot of named navigation entries.
class RestorableRouteHistory {
  RestorableRouteHistory._(this.scope, this.entries, this._encoded);

  static const _namespace = 'getx.navigationHistory';
  static const _version = 1;
  static const maxEntries = 128;
  static const maxBytes = 64 * 1024;
  final String scope;
  final List<RestorableRouteEntry> entries;
  final String _encoded;

  static RestorableRouteHistory? create(
    String scope,
    List<RestorableRouteEntry> entries,
  ) {
    if (scope.isEmpty || entries.isEmpty || entries.length > maxEntries) {
      return null;
    }
    final ids = <int>{};
    if (scope.length > maxBytes) return null;
    try {
      for (final entry in entries) {
        if (entry.id < 0 || entry.id >= 9007199254740991 ||
            !ids.add(entry.id) || !entry.uri.path.startsWith('/') ||
            entry.uri.hasScheme || entry.uri.hasAuthority ||
            entry.uri.toString().length > maxBytes) {
          return null;
        }
      }
      final values = _RestorationValues();
      final detachedEntries = [
        for (final entry in entries)
          RestorableRouteEntry(entry.id, entry.uri,
              values.copy(entry.arguments), entry.preventDuplicates),
      ];
      final raw = {
        _namespace: {
          'version': _version,
          'scope': scope,
          'entries': [for (final entry in detachedEntries) entry._toPrimitives()],
        }
      };
      final detached = _RestorationValues().copy(raw) as Map;
      final encoded = jsonEncode(detached);
      if (utf8.encode(encoded).length > maxBytes) return null;
      return RestorableRouteHistory._(
          scope, List.unmodifiable(detachedEntries), encoded);
    } on FormatException {
      return null;
    }
  }

  static RestorableRouteHistory? decode(Object? state, Uri selectedUri) {
    if (state is! Map) return null;
    final payload = state[_namespace];
    if (payload is! Map ||
        payload['version'] != _version ||
        payload['scope'] is! String ||
        payload['entries'] is! List) {
      return null;
    }
    final raw = payload['entries'] as List;
    if (raw.isEmpty || raw.length > maxEntries) return null;
    final entries = <RestorableRouteEntry>[];
    try {
      for (final entry in raw) {
        if (entry is! Map || entry['uri'] is! String ||
            entry['preventDuplicates'] is! bool ||
            entry['argumentsJson'] is! String) {
          return null;
        }
        final id = entry['id'];
        if (id is! num || !id.isFinite || id < 0 ||
            id >= 9007199254740991 || id.truncateToDouble() != id ||
            (entry['uri'] as String).length > maxBytes ||
            (entry['argumentsJson'] as String).length > maxBytes) {
          return null;
        }
        final uri = Uri.tryParse(entry['uri'] as String);
        if (uri == null) return null;
        entries.add(RestorableRouteEntry(id.toInt(), uri,
            jsonDecode(entry['argumentsJson'] as String),
            entry['preventDuplicates'] as bool));
      }
    } on FormatException {
      return null;
    }
    if (entries.last.uri != selectedUri) return null;
    return create(payload['scope'] as String, entries);
  }

  Object toPrimitives() => jsonDecode(_encoded) as Object;

  @override
  bool operator ==(Object other) =>
      other is RestorableRouteHistory && _encoded == other._encoded;

  @override
  int get hashCode => _encoded.hashCode;
}

/// An internal named page instance and its supported restoration arguments.
class RestorableRouteEntry {
  const RestorableRouteEntry(
    this.id,
    this.uri,
    this.arguments,
    this.preventDuplicates,
  );

  final int id;
  final Uri uri;
  final Object? arguments;
  final bool preventDuplicates;

  Map<String, Object?> _toPrimitives() => {
    'id': id,
    'uri': uri.toString(),
    'argumentsJson': jsonEncode(arguments),
    'preventDuplicates': preventDuplicates,
  };

  Object? copyArguments() => jsonDecode(jsonEncode(arguments));

  bool hasArguments(Object? candidate) {
    try {
      return jsonEncode(arguments) ==
          jsonEncode(_RestorationValues().copy(candidate));
    } on FormatException {
      return false;
    }
  }
}

class _RestorationValues {
  final _active = HashSet<Object>.identity();
  int _remaining = RestorableRouteHistory.maxBytes;
  int _nodes = RestorableRouteHistory.maxBytes;

  void _charge(int bytes) {
    if (bytes > _remaining) {
      throw const FormatException('Restoration arguments exceed the byte limit.');
    }
    _remaining -= bytes;
  }

  Object? copy(Object? value, [int depth = 0]) {
    if (--_nodes < 0 || depth > 16) {
      throw const FormatException('Restoration arguments exceed limits.');
    }
    if (value == null || value is bool || value is int ||
        (value is double && value.isFinite)) {
      _charge(jsonEncode(value).length);
      return value;
    }
    if (value is String && value.length <= RestorableRouteHistory.maxBytes) {
      _charge(utf8.encode(jsonEncode(value)).length);
      return value;
    }
    if ((value is! List && value is! Map) || !_active.add(value)) {
      throw const FormatException('Unsupported or cyclic restoration arguments.');
    }
    try {
      if (value is List && value.length <= RestorableRouteHistory.maxBytes) {
        _charge(2 + (value.isEmpty ? 0 : value.length - 1));
        return List<Object?>.unmodifiable(
            value.map((item) => copy(item, depth + 1)));
      }
      if (value is Map && value.length <= RestorableRouteHistory.maxBytes) {
        _charge(2 + (value.isEmpty ? 0 : value.length * 2 - 1));
        final keys = <String>[];
        for (final key in value.keys) {
          if (key is! String) {
            throw const FormatException('Restoration map keys must be strings.');
          }
          copy(key, depth + 1);
          keys.add(key);
        }
        keys.sort();
        return Map<String, Object?>.unmodifiable(
            {for (final key in keys) key: copy(value[key], depth + 1)});
      }
      throw const FormatException('Unsupported restoration arguments.');
    } finally {
      _active.remove(value);
    }
  }
}

class ParseRouteTree {
  ParseRouteTree({
    required this.routes,
  });

  final List<GetPage> routes;

  RouteDecoder matchRoute(String name, {PageSettings? arguments}) {
    final uri = Uri.parse(name);
    final split = uri.path.split('/').where((element) => element.isNotEmpty);
    var curPath = '/';
    final cumulativePaths = <String>[
      '/',
    ];
    for (var item in split) {
      if (curPath.endsWith('/')) {
        curPath += item;
      } else {
        curPath += '/$item';
      }
      cumulativePaths.add(curPath);
    }

    final treeBranch = cumulativePaths
        .map((e) => MapEntry(e, _findRoute(e)))
        .where((element) => element.value != null)

        ///Prevent page be disposed
        .map((e) => MapEntry(e.key, e.value!.copyWith(key: ValueKey(e.key))))
        .toList();

    final params = Map<String, String>.from(uri.queryParameters);
    if (treeBranch.isNotEmpty) {
      //route is found, do further parsing to get nested query params
      final lastRoute = treeBranch.last;
      final parsedParams = _parseParams(name, lastRoute.value.path);
      if (parsedParams.isNotEmpty) {
        params.addAll(parsedParams);
      }
      //copy parameters to all pages.
      final mappedTreeBranch = treeBranch
          .map(
            (e) => e.value.copyWith(
              parameters: {
                if (e.value.parameters != null) ...e.value.parameters!,
                ...params,
              },
              name: e.key,
            ),
          )
          .toList();
      arguments?.params.clear();
      arguments?.params.addAll(params);
      return RouteDecoder(
        mappedTreeBranch,
        arguments,
      );
    }

    arguments?.params.clear();
    arguments?.params.addAll(params);

    //route not found
    return RouteDecoder(
      treeBranch.map((e) => e.value).toList(),
      arguments,
    );
  }

  void addRoutes<T>(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      addRoute(route);
    }
  }

  void removeRoutes<T>(List<GetPage<T>> getPages) {
    for (final route in getPages) {
      removeRoute(route);
    }
  }

  void removeRoute<T>(GetPage<T> route) {
    routes.remove(route);
    for (var page in _flattenPage(route)) {
      removeRoute(page);
    }
  }

  void addRoute<T>(GetPage<T> route) {
    routes.add(route);

    // Add Page children.
    for (var page in _flattenPage(route)) {
      addRoute(page);
    }
  }

  List<GetPage> _flattenPage(GetPage route) {
    final result = <GetPage>[];
    if (route.children.isEmpty) {
      return result;
    }

    final parentPath = route.name;
    for (var page in route.children) {
      // Add Parent middlewares to children
      final parentMiddlewares = [
        if (page.middlewares.isNotEmpty) ...page.middlewares,
        if (route.middlewares.isNotEmpty) ...route.middlewares
      ];

      final parentBindings = [
        if (page.binding != null) page.binding!,
        if (page.bindings.isNotEmpty) ...page.bindings,
        if (route.bindings.isNotEmpty) ...route.bindings
      ];

      final parentBinds = [
        if (page.binds.isNotEmpty) ...page.binds,
        if (route.binds.isNotEmpty) ...route.binds
      ];

      result.add(
        _addChild(
          page,
          parentPath,
          parentMiddlewares,
          parentBindings,
          parentBinds,
        ),
      );

      final children = _flattenPage(page);
      for (var child in children) {
        result.add(_addChild(
          child,
          parentPath,
          [
            ...parentMiddlewares,
            if (child.middlewares.isNotEmpty) ...child.middlewares,
          ],
          [
            ...parentBindings,
            if (child.binding != null) child.binding!,
            if (child.bindings.isNotEmpty) ...child.bindings,
          ],
          [
            ...parentBinds,
            if (child.binds.isNotEmpty) ...child.binds,
          ],
        ));
      }
    }
    return result;
  }

  /// Change the Path for a [GetPage]
  GetPage _addChild(
    GetPage origin,
    String parentPath,
    List<GetMiddleware> middlewares,
    List<BindingsInterface> bindings,
    List<Bind> binds,
  ) {
    return origin.copyWith(
      middlewares: middlewares,
      name: origin.inheritParentPath
          ? (parentPath + origin.name).replaceAll(r'//', '/')
          : origin.name,
      bindings: bindings,
      binds: binds,
      // key:
    );
  }

  GetPage? _findRoute(String name) {
    final value = routes.firstWhereOrNull(
      (route) => route.path.regex.hasMatch(name),
    );

    return value;
  }

  Map<String, String> _parseParams(String path, PathDecoded routePath) {
    final params = <String, String>{};
    var idx = path.indexOf('?');
    final uri = Uri.tryParse(path);
    if (uri == null) return params;
    if (idx > -1) {
      params.addAll(uri.queryParameters);
    }
    var paramsMatch = routePath.regex.firstMatch(uri.path);
    if (paramsMatch == null) {
      return params;
    }
    for (var i = 0; i < routePath.keys.length; i++) {
      var param = Uri.decodeComponent(paramsMatch[i + 1]!);
      params[routePath.keys[i]!] = param;
    }
    return params;
  }
}

extension FirstWhereOrNullExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
