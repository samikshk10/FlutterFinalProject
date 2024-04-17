import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/material.dart';

final EzSchema eventSchema = EzSchema.shape({
  "title": EzValidator<String>(label: "title").required(),
  "description": EzValidator<String>(label: 'description').required(),
  "location": EzValidator<String>(label: 'location').required(),
  "duration": EzValidator<String>(label: 'duration').required(),
  "startDate":
      EzValidator<DateTime>().required().date().minDate(DateTime.now()),
  "endDate": EzValidator<DateTime>().required().date(),
  "startTime": EzValidator<TimeOfDay>().required(),
  "endTime": EzValidator<TimeOfDay>().required(),
  "category": EzValidator<String>().required(),
  "imageUrl": EzValidator<String>().required(),
  "punchLine": EzValidator<String>().required(),
});
