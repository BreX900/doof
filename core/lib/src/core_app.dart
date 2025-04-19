import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

class CoreApp extends StatefulWidget {
  final String initialLocation;
  final Map<SignStatus?, List<RouteBase>> routes;
  final String? Function(GoRouterState state, SignStatus signStatus) redirect;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final ThemeData? theme;

  const CoreApp({
    super.key,
    required this.initialLocation,
    required this.routes,
    required this.redirect,
    this.localizationsDelegates = const [],
    this.theme,
  });

  static GoRouter routerOf(BuildContext context) =>
      context.findAncestorStateOfType<_CoreAppState>()!.router;

  @override
  State<CoreApp> createState() => _CoreAppState();
}

class _CoreAppState extends State<CoreApp> {
  late GoRouter _router;
  GoRouter get router => _router;

  @override
  void initState() {
    super.initState();
    _initRouter();
    unawaited(_listenSignStatus());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  void _initRouter() {
    _router = GoRouter(
      routes: widget.routes.values.flattened.toList(),
      redirect: _safeRedirect,
      initialLocation: widget.initialLocation,
    );
  }

  Future<void> _listenSignStatus() async {
    UsersProviders.signStatusController.skip(1).distinct().listen((status) {
      _router.dispose();
      _initRouter();
      setState(() {});
    });
  }

  Future<String?> _safeRedirect(BuildContext context, GoRouterState state) async {
    final nextLocation = await _redirect(context, state);
    return nextLocation == null || state.uri.toString() == nextLocation ? null : nextLocation;
  }

  Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final signStatus = await UsersProviders.signStatusController.first;

    switch (signStatus) {
      case SignStatus.none:
        return widget.redirect(state, signStatus);
      case SignStatus.unverified:
        final routes = widget.routes[SignStatus.unverified] ?? const [];
        if (state.isLocationIn(routes)) return null;
        return widget.redirect(state, signStatus);
      case SignStatus.partial:
        final routes = widget.routes[SignStatus.partial] ?? const [];
        if (state.isLocationIn(routes)) return null;
        return widget.redirect(state, signStatus);
      case SignStatus.full:
        return widget.redirect(state, signStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    const locale = Locale.fromSubtags(languageCode: 'it', countryCode: 'IT');

    final key = ValueKey(UsersProviders.signStatusController.valueOrNull);

    final app = MaterialApp.router(
      key: key,
      locale: locale,
      supportedLocales: const [locale],
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        const ValidationLocalizations(),
        ...widget.localizationsDelegates,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Doof App',
      theme: widget.theme ?? MekTheme.build(context: context),
      routerConfig: _router,
      builder: (context, child) => MekReactiveFormConfig(child: child!),
    );

    return ProviderScope(
      key: key,
      observers: const [Observers.provider],
      child: app,
    );
  }
}

extension CheckIsInGoRouterState on GoRouterState {
  bool isLocationIn(Iterable<RouteBase> routes) {
    return routes.any((e) {
      if (e is GoRoute && e.matchPatternAsPrefix(uri.path) != null) return true;
      return isLocationIn(e.routes.cast());
    });
  }
}
