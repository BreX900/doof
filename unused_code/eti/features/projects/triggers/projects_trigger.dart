import 'package:mek_gasol/modules/eti/features/projects/repositories/projects_repo.dart';
import 'package:riverpod/riverpod.dart';

abstract class ProjectsTrigger {
  static final all = StreamProvider.family((ref, String clientId) {
    final projects = ref.watch(ProjectsRepo.instance);

    return projects.watchAll(clientId);
  });
}
