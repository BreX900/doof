import 'package:core/src/features/ingredients/repositories/ingredients_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LevelsProviders {
  static final all = FutureProvider.family((ref, (String organizationId,) args) async {
    final (organizationId,) = args;
    return await LevelsRepository.instance.fetchAll(organizationId);
  });
}
