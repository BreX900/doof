import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/organizations/repositories/organizations_repository.dart';
import 'package:core/src/features/products/dto/product_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:pure_extensions/pure_extensions.dart';

class ProductsRepository {
  static ProductsRepository get instance => ProductsRepository._();
  static const String collection = 'products';

  FirebaseFirestore get _firestore => Instances.firestore;

  ProductsRepository._();

  CollectionReference<ProductDto> _ref(String organizationId) => _firestore
      .collection(OrganizationsRepository.collection)
      .doc(organizationId)
      .collection(collection)
      .withJsonConverter(ProductDto.fromJson);

  Future<void> upsert(String organizationId, ProductDto product) async {
    await _ref(organizationId).doc(product.id.nullIfEmpty()).set(product);
  }

  Future<void> delete(String organizationId, ProductDto product) async {
    await _ref(organizationId).doc(product.id).delete();
  }

  Future<ProductDto> fetch(String organizationId, String id) async {
    final snapshot = await _ref(organizationId).doc(id).get();
    return snapshot.data()!;
  }

  Future<IList<ProductDto>> fetchAll(String organizationId) async {
    final snapshot = await _ref(organizationId).orderBy(ProductDto.fields.title).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }

  Future<IList<ProductDto>> fetchPage(String organizationId, Cursor cursor) async {
    final snapshot = await _ref(organizationId).apply(cursor).get();
    return snapshot.docs.map((e) => e.data()).toIList();
  }
}
