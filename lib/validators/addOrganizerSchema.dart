import 'package:ez_validator/ez_validator.dart';

final EzSchema addOrganizerSchema = EzSchema.shape({
  "organizerName": EzValidator<String>(label: "organizerName").required(),
  "description": EzValidator<String>(label: 'description').required(),
  "websiteUrl": EzValidator<String>(label: 'websiteUrl'),
  "phoneNumber": EzValidator<String>(label: 'phoneNumber')
      .required()
      .number()
      .minLength(10),
});
