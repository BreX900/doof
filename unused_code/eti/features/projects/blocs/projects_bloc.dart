import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/repositories/projects_repo.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:riverpod/riverpod.dart';

class ProjectsBloc {
  static final instance = Provider((ref) {
    return ProjectsBloc._(ref);
  });

  final Ref _ref;

  ProjectsRepo get _projects => _ref.watch(ProjectsRepo.instance);

  ProjectsBloc._(this._ref);

  Future<void> save(String clientId, ProjectDvo project) async {
    await _projects.save(clientId, project);
  }

  static final all = FutureProvider.family((ref, String clientId) async {
    return await ref.watch(ProjectsTrigger.all(clientId).future);
  });
}
