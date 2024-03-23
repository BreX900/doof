import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/auth_guard.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/calendar_events.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/calendar_rules.dart';
import 'package:mek_gasol/shared/theme.dart';

/// Work Time Tracker App
class EtiApp extends StatelessWidget {
  const EtiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      builder: (context, child) => MaterialApp(
        key: ValueKey(child),
        locale: const Locale.fromSubtags(languageCode: 'it'),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          ValidationLocalizations(),
        ],
        supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
        debugShowCheckedModeBanner: false,
        title: 'Mek Gasol',
        theme: AppTheme.build(),
        home: child ?? const _AuthenticatedArea(),
      ),
    );
  }
}

enum _Tab { events, rules }

final _tab = StateProvider((ref) => _Tab.events);

class _AuthenticatedArea extends ConsumerWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tab);

    Widget buildTab() {
      switch (tab) {
        case _Tab.events:
          return const CalendarScreen();
        case _Tab.rules:
          return const CalendarRuleScreen();
      }
    }

    BottomNavigationBarItem buildBottomBarItem(_Tab tab) {
      switch (tab) {
        case _Tab.events:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          );
        case _Tab.rules:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Rules',
          );
      }
    }

    return Scaffold(
      body: buildTab(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => ref.read(_tab.notifier).state = _Tab.values[index],
        items: _Tab.values.map(buildBottomBarItem).toList(),
      ),
    );
  }
}
