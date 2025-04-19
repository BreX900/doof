import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

abstract class DateTimeUtils {
  static DateTime darwinAdd(DateTime dateTime, int months) {
    final totalMonths = (dateTime.month - 1) + months;
    final newMonth = (totalMonths % DateTime.monthsPerYear) + 1;
    final years = totalMonths ~/ DateTime.monthsPerYear;
    return dateTime.copyWith(year: dateTime.year + years, month: newMonth);
  }
}

abstract class FutureUtils {
  static Future<IList<R>> map<E, R>(Iterable<E> elements, FutureOr<R> Function(E e) mapper) async {
    final results = <R>[];
    for (final element in elements) {
      results.add(await mapper(element));
    }
    return results.toIList();
  }
}

extension CopyUpToDateTime on DateTime {
  DateTime copyUpTo({
    bool month = false,
    bool day = false,
    bool hour = false,
    bool minute = false,
    bool second = false,
    bool millisecond = false,
    bool microsecond = false,
  }) {
    return copyWith(
      month: month || day || hour || minute || second || millisecond || microsecond ? null : 1,
      day: day || hour || minute || second || millisecond || microsecond ? null : 1,
      hour: hour || minute || second || millisecond || microsecond ? null : 0,
      minute: minute || second || millisecond || microsecond ? null : 0,
      second: second || millisecond || microsecond ? null : 0,
      millisecond: millisecond || microsecond ? null : 0,
      microsecond: microsecond ? null : 0,
    );
  }
}

extension BetweenDateTime on DateTime {
  bool isBetween(DateTime after, DateTime before) =>
      (this == after || isAfter(after)) && (this == before || isBefore(before));
}

extension EqualsDateTime on DateTime {
  bool equalsUpTo(
    DateTime other, {
    bool year = false,
    bool month = false,
    bool day = false,
    bool hour = false,
    bool minute = false,
    bool second = false,
    bool millisecond = false,
  }) {
    if (this.year != other.year) return false;
    if (year) return true;
    if (this.month != other.month) return false;
    if (month) return true;
    if (this.day != other.day) return false;
    if (day) return true;
    if (this.hour != other.hour) return false;
    if (hour) return true;
    if (this.minute != other.minute) return false;
    if (minute) return true;
    if (this.second != other.second) return false;
    if (second) return true;
    if (this.millisecond != other.millisecond) return false;
    if (millisecond) return true;
    return true;
  }
}
