import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/ingredients/dto/ingredient_dto.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pure_extensions/pure_extensions.dart';

class LevelsRepository {
  static LevelsRepository get instance => LevelsRepository._();
  static const String collection = 'levels';

  FirebaseFirestore get _firestore => Instances.firestore;

  LevelsRepository._();

  CollectionReference<LevelDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(LevelDto.fromJson);

  Future<void> save(String organizationId, LevelDto level) async {
    await _ref(organizationId).doc(level.id.nullIfEmpty()).set(level);
  }

  Future<void> delete(String organizationId, LevelDto level) async {
    await _ref(organizationId).doc(level.id).delete();
  }

  Future<IList<LevelDto>> fetchAll(String organizationId) async {
    final snapshot = await _ref(organizationId)
        // .where(IngredientDto.fields.productIds, arrayContains: productId)
        .orderBy(LevelDto.fields.title)
        .get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  // Stream<List<IngredientDto>> watch(String productId) {
  //   return _ref()
  //       .where(IngredientDto.fields.productIds, arrayContains: productId)
  //       .orderBy(IngredientDto.fields.title)
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => e.data()).toList());
  // }
}
