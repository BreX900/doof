import 'package:flutter/material.dart';
import 'package:mek/mek.dart';

extension ToDateTimeOnTimeOfDay on TimeOfDay {
  DateTime toDateTime(DateTime original) => original.copyWith(hour: hour, minute: minute);
}

extension ToDurationOnTimeOfDay on TimeOfDay {
  Duration toDuration() => Duration(hours: hour, minutes: minute);
}

class Validations {
  static final Validation<String> firestoreSegment =
      TextValidation(match: RegExp(r'^(?!__.*__)[^/.]{0,1500}$'));
}
