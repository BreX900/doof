import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/organizations/dto/organization_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

class OrganizationsRepository {
  static OrganizationsRepository get instance => OrganizationsRepository._();
  static const String collection = 'organizations';

  FirebaseFirestore get _firestore => Instances.firestore;

  OrganizationsRepository._();

  CollectionReference<OrganizationDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(OrganizationDto.fromJson);

  Future<void> save(OrganizationDto organization) async {
    await _ref().doc(organization.id.nullIfEmpty).set(organization);
  }

  Future<void> delete(OrganizationDto organization) async {
    await _ref().doc(organization.id).delete();
  }

  Future<OrganizationDto> fetch(String organizationId) async {
    final snapshot = await _ref().doc(organizationId).get();
    return snapshot.data()!;
  }

  Future<IList<OrganizationDto>> fetchPage(Cursor cursor) async {
    final snapshot = await _ref().apply(cursor).get();
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
