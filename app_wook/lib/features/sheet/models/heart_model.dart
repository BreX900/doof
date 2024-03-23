import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';

part 'heart_model.g.dart';

@DataClass()
class LifeBar with _$LifeBar {
  static const int hearts = 5;

  final UserDto user;
  final Life data;
  final int full;
  final int missed;

  final IList<Job> kingJobs;

  final bool hasManyPresences;
  final bool hasMorePoints;
  final bool hasLessPoints;

  int get broken => hearts - full - missed;

  const LifeBar(
    this.user,
    this.data,
    this.full,
    this.missed, {
    required this.kingJobs,
    required this.hasManyPresences,
    required this.hasMorePoints,
    required this.hasLessPoints,
  });
}

@DataClass()
class Life with _$Life {
  final int presenceCount;
  final IMap<Job, int> jobs;

  Life({
    required this.presenceCount,
    required this.jobs,
  });

  late final int jobsCount = jobs.values.sum;

  late final IMap<Job, double> points =
      jobs.map((action, count) => MapEntry(action, action.points * count));

  late final double pointsGainedCount = points.values.fold(0.0, (count, e) => count + e);

  late final double pointsLostCount = presenceCount * Job.eaterPoints;

  late final double pointsCount = pointsGainedCount + pointsLostCount;

  late final double life = pointsCount / presenceCount;

  @override
  String toString() {
    return '${super.toString()}\n'
        ' jobsCount: $jobsCount\n'
        ' points: $points\n'
        ' pointsGainedCount: $pointsGainedCount\n'
        ' pointsLostCount: $pointsLostCount\n'
        ' pointsCount: $pointsCount\n'
        ' life: $life';
  }
}
