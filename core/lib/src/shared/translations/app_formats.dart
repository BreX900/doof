import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppFormats {
  final String _locale;

  static const LocalizationsDelegate<AppFormats> delegate = _DoofTranslationsDelegate();

  const AppFormats._({
    required String locale,
  }) : _locale = locale;

  static AppFormats of(BuildContext context) => Localizations.of(context, AppFormats)!;

  NumberFormat get decimal => NumberFormat.decimalPatternDigits(locale: _locale, decimalDigits: 2);

  String formatPrice(Decimal price) {
    return DecimalFormatter(NumberFormat.compactSimpleCurrency(
      locale: _locale,
      name: 'EUR',
    )).format(price);
  }

  String formatCaps(Decimal price) => '${DecimalFormatter(decimal).format(price)} caps';

  String formatDouble(double value) =>
      NumberFormat.decimalPatternDigits(locale: _locale, decimalDigits: 2).format(value);

  String formatPercent(double value) => NumberFormat.percentPattern(_locale).format(value);

  String formatDate(DateTime date) => DateFormat.yMd(_locale).format(date);

  String formatDateTime(DateTime date) => DateFormat.yMd(_locale).add_Hm().format(date);

  String formatMonth(DateTime date) => DateFormat('MMM', _locale).format(date).toUpperCase();
}

class _DoofTranslationsDelegate extends LocalizationsDelegate<AppFormats> {
  const _DoofTranslationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppFormats> load(Locale locale) =>
      SynchronousFuture(AppFormats._(locale: locale.toString()));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppFormats> old) => true;
}
