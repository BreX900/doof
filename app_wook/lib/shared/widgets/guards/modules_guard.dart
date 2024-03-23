import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:mek/mek.dart';

class AppsGuard<T extends Enum> extends StatefulWidget {
  final List<T> values;
  final T? current;
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, bool isLoading) pickerBuilder;
  final Widget Function(BuildContext context, T value) builder;

  const AppsGuard({
    super.key,
    required this.values,
    this.current,
    required this.pickerBuilder,
    required this.builder,
  });

  static AppsGuardState<T> of<T extends Enum>(BuildContext context) =>
      context.findAncestorStateOfType()!;

  @override
  State<AppsGuard<T>> createState() => AppsGuardState();
}

class AppsGuardState<T extends Enum> extends State<AppsGuard<T>> {
  static final Bin<String> _bin = Bin(name: 'module', deserializer: (data) => data as String);
  late bool _isLoading;
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
    if (_selected == null) {
      _isLoading = true;
      unawaited(_loadModule());
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadModule() async {
    final moduleName = await _bin.readOrNull();
    final module = widget.values.firstWhereOrNull((e) => e.name == moduleName);
    setState(() {
      _isLoading = false;
      _selected = module;
    });
  }

  Future<void> select(T? app) async {
    if (_selected == app) return;
    if (app == null) {
      await _bin.delete();
    } else {
      await _bin.write(app.name);
    }
    setState(() => _selected = app);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_selected) {
      case null:
        child = widget.pickerBuilder(context, _isLoading);
      default:
        child = widget.builder(context, _selected!);
    }
    return KeyedSubtree(
      key: ValueKey(_selected),
      child: child,
    );
  }
}
