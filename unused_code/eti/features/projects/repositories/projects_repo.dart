import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/shared/firestore.dart';
import 'package:riverpod/riverpod.dart';

class ProjectsRepo {
  static final instance = Provider((ref) {
    return ProjectsRepo(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  ProjectsRepo(this._ref);

  CollectionReference<ProjectDvo> _getCollection(String clientId) {
    return _firestore
        .collection('clients')
        .doc(clientId)
        .collection('projects')
        .withJsonConverter(ProjectDvo.fromJson);
  }

  Future<void> save(String clientId, ProjectDvo project) async {
    await _getCollection(clientId).add(project);
  }

  Stream<List<ProjectDvo>> watchAll(String clientId) {
    final projectsQuery = _getCollection(clientId).orderBy(ProjectDvo.nameKey, descending: false);

    return projectsQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
