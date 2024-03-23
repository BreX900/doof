// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_model.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$LifeBar {
  LifeBar get _self => this as LifeBar;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifeBar &&
          runtimeType == other.runtimeType &&
          _self.data == other.data &&
          _self.full == other.full &&
          _self.missed == other.missed &&
          _self.kingJobs == other.kingJobs &&
          _self.hasManyPresences == other.hasManyPresences &&
          _self.hasMorePoints == other.hasMorePoints &&
          _self.hasLessPoints == other.hasLessPoints;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.data.hashCode);
    hashCode = $hashCombine(hashCode, _self.full.hashCode);
    hashCode = $hashCombine(hashCode, _self.missed.hashCode);
    hashCode = $hashCombine(hashCode, _self.kingJobs.hashCode);
    hashCode = $hashCombine(hashCode, _self.hasManyPresences.hashCode);
    hashCode = $hashCombine(hashCode, _self.hasMorePoints.hashCode);
    hashCode = $hashCombine(hashCode, _self.hasLessPoints.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('LifeBar')
        ..add('data', _self.data)
        ..add('full', _self.full)
        ..add('missed', _self.missed)
        ..add('kingJobs', _self.kingJobs)
        ..add('hasManyPresences', _self.hasManyPresences)
        ..add('hasMorePoints', _self.hasMorePoints)
        ..add('hasLessPoints', _self.hasLessPoints))
      .toString();
}

mixin _$Life {
  Life get _self => this as Life;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Life &&
          runtimeType == other.runtimeType &&
          _self.presenceCount == other.presenceCount &&
          _self.jobs == other.jobs;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.presenceCount.hashCode);
    hashCode = $hashCombine(hashCode, _self.jobs.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('Life')
        ..add('presenceCount', _self.presenceCount)
        ..add('jobs', _self.jobs))
      .toString();
}
