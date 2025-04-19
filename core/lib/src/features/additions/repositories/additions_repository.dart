import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

class IngredientsRepository {
  static IngredientsRepository get instance => IngredientsRepository._();
  static const String collection = 'ingredients';

  FirebaseFirestore get _firestore => Instances.firestore;

  IngredientsRepository._();

  CollectionReference<IngredientDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(IngredientDto.fromJson);

  Future<void> upsert(String organizationId, IngredientDto ingredient) async {
    await _ref(organizationId).doc(ingredient.id.nullIfEmpty).set(ingredient);
  }

  Future<void> delete(String organizationId, IngredientDto ingredient) async {
    await _ref(organizationId).doc(ingredient.id).delete();
  }

  Future<IngredientDto> fetch(String organizationId, String id) async {
    final snapshot = await _ref(organizationId).doc(id).get();
    return snapshot.data()!;
  }

  Future<IList<IngredientDto>> fetchAll(String organizationId) async {
    final snapshot = await _ref(organizationId)
        // .where(IngredientDto.fields.productIds, arrayContains: productId)
        .orderBy(IngredientDtoFields.title)
        .get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  Future<IList<IngredientDto>> fetchPage(String organizationId, Cursor cursor) async {
    final snapshot = await _ref(organizationId).apply(cursor).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }
}
