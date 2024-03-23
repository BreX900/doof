import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek/mek.dart';

extension CollectionReferenceExtensions<T> on CollectionReference<T> {
  Query<T> asQuery() => this;

  CollectionReference<R> withJsonConverter<R extends Object>(
    R Function(Map<String, dynamic> json) fromFirestore, [
    Set<String> pathKeys = const {},
  ]) {
    return asQuery().withJsonConverter(fromFirestore) as CollectionReference<R>;
  }
}

extension QueryExtensions<T> on Query<T> {
  Query<R> withJsonConverter<R extends Object>(
    R Function(Map<String, dynamic> json) fromFirestore, [
    Set<String> pathKeys = const {},
  ]) {
    final sortedPathKeys = {...pathKeys, 'id'}.toList().reversed.toList();
    return withConverter<R>(fromFirestore: (snapshot, _) {
      DocumentReference<Object?>? pathRef = snapshot.reference;
      final pathValues = <String, dynamic>{};
      for (final pathKey in sortedPathKeys) {
        pathValues[pathKey] = pathRef!.id;
        final collectionRef = snapshot.reference.parent;
        if (collectionRef.path.contains('/')) pathRef = collectionRef.parent;
      }
      return fromFirestore({...pathValues, ...snapshot.data()!});
    }, toFirestore: (value, _) {
      // ignore: avoid_dynamic_calls
      final json = {...(value as dynamic).toJson() as Map<String, dynamic>};
      sortedPathKeys.forEach(json.remove);
      return json;
    });
  }

  Query<T> apply(Cursor cursor) {
    var query = this;
    final prevPageLastOffset = cursor.prevPageLastOffset;
    if (prevPageLastOffset != null) {
      query = orderBy(FieldPath.documentId).startAfter([prevPageLastOffset]);
    }
    return query.limit(cursor.size);
  }
}
