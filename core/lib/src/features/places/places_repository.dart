import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/apis/firebase/firestore.dart';
import 'package:core/src/features/places/dto/place_dto.dart';
import 'package:core/src/shared/instances.dart';

class PlacesRepository {
  static PlacesRepository get instance => PlacesRepository._();
  static const String collection = 'places';

  FirebaseFirestore get _firestore => Instances.firestore;

  PlacesRepository._();

  CollectionReference<PlaceDto> _ref() =>
      _firestore.collection(collection).withJsonConverter(PlaceDto.fromJson);

  Future<bool> checkExist(String id) async {
    if (id.isEmpty) return false;
    final place = await _ref().doc(id).get();
    return place.exists;
  }
}
