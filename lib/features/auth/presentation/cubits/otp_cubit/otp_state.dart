abstract class OtpState {}

class OtpInitial extends OtpState {}
class OtpSuccess extends OtpState {}
class OtpError extends OtpState {
  final String message;
  OtpError({required this.message});
}