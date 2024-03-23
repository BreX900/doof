import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_guard.dart';

class AppsApp<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Widget Function(BuildContext context, T value)? descriptionBuilder;
  final Widget? bottom;
  final bool isLoading;

  const AppsApp({
    super.key,
    required this.values,
    this.descriptionBuilder,
    this.bottom,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MekTheme.build(),
      home: _AppsScreen(
        values: values,
        descriptionBuilder: descriptionBuilder,
        bottom: bottom,
        isLoading: isLoading,
      ),
    );
  }
}

class _AppsScreen<T extends Enum> extends StatelessWidget {
  final List<T> values;
  final Widget Function(BuildContext context, T value)? descriptionBuilder;
  final Widget? bottom;
  final bool isLoading;

  const _AppsScreen({
    required this.values,
    this.descriptionBuilder,
    this.bottom,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildBody() {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final bottom = this.bottom;

      return Column(
        children: [
          ...values.map((e) {
            return ListTile(
              onTap: () => unawaited(AppsGuard.of<T>(context).select(e)),
              title: Text(e.name),
              subtitle: descriptionBuilder?.call(context, e),
            );
          }),
          const Spacer(),
          if (bottom != null) bottom,
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modules'),
      ),
      body: buildBody(),
    );
  }
}
