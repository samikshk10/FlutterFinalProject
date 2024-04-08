import 'package:ez_validator/ez_validator.dart';

final EzSchema userSchema = EzSchema.shape({
  "email": EzValidator<String>(label: "Email").required().email(),
  "password": EzValidator<String>(label: 'Password').required().minLength(8),
});
