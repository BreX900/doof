import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/categories/dto/category_dto.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:pure_extensions/pure_extensions.dart';

class CategoriesRepository {
  static CategoriesRepository get instance => CategoriesRepository._();
  static const String collection = 'categories';

  FirebaseFirestore get _firestore => Instances.firestore;

  CategoriesRepository._();

  CollectionReference<CategoryDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(CategoryDto.fromJson);

  Future<void> upsert(String organizationId, CategoryDto category) async {
    await _ref(organizationId).doc(category.id.nullIfEmpty()).set(category);
  }

  Future<void> delete(String organizationId, CategoryDto category) async {
    await _ref(organizationId).doc(category.id).delete();
  }

  Future<CategoryDto> fetch(String organizationId, String id) async {
    final snapshot = await _ref(organizationId).doc(id).get();
    return snapshot.data()!;
  }

  Future<IList<CategoryDto>> fetchAll(String organizationId) async {
    final snapshot = await _ref(organizationId).orderBy(CategoryDto.fields.weight).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  Future<IList<CategoryDto>> fetchPage(String organizationId, Cursor cursor) async {
    final snapshot = await _ref(organizationId).apply(cursor).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }
}
