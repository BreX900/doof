import 'package:app_button/shared/data/mek_widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';

class AppTheme {
  static ThemeData build({Brightness? brightness}) {
    final colors = ColorScheme.fromSeed(
      brightness: brightness ?? PlatformDispatcher.instance.platformBrightness,
      seedColor: const Color(0xFF007AFF),
    );
    return ThemeData.from(
      colorScheme: colors,
    ).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(kMinInteractiveDimension, kMinInteractiveDimension),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.primary),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        titleAlignment: ListTileTitleAlignment.center,
      ),
      dividerTheme: const DividerThemeData(space: 1.0),
      appBarTheme: const AppBarTheme(centerTitle: true),
      cardTheme: const CardTheme(
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
        ),
      ),
      extensions: {
        const DataBuilders(
          errorListener: CoreUtils.showErrorByData,
          errorBuilder: ErrorView.buildByData,
        )
      },
    );
  }
}
