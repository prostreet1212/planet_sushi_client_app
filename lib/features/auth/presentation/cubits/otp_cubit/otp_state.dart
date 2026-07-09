import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}
class OtpSuccess extends OtpState {
  UserModel? user;
  OtpSuccess({required this.user});
}
class OtpNext extends OtpState {}
class OtpError extends OtpState {
  final String message;
  OtpError({required this.message});
}