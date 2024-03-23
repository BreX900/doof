import 'package:collection/collection.dart';

mixin Identifiable {
  String get id;
}

extension IdentifiableIterable<T extends Identifiable> on Iterable<T> {
  Iterable<String> get ids => map((e) => e.id);

  bool containsId(String id) => any((e) => e.id == id);
  T firstWhereId(String id) => firstWhere((e) => e.id == id);
  T? firstWhereIdOrNull(String? id) => id != null ? firstWhereOrNull((e) => e.id == id) : null;
  Iterable<T> whereIds(Iterable<String> ids) => where((e) => ids.contains(e.id));
}
