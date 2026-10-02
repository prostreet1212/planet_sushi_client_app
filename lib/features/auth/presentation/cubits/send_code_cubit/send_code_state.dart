
abstract class SendCodeState {}

class SendCodeInitial extends SendCodeState {}
class SendCodeSuccess extends SendCodeState {}
class SendCodeSkip extends SendCodeState {}

class SendCodeError extends SendCodeState {
  final String message;
  SendCodeError({required this.message});
}