import 'package:flutter/cupertino.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpState extends ChangeNotifier{
  final _pinController = PinInputController();
  final _formKey = GlobalKey<FormState>();
  bool _otpIsValid=true;

  PinInputController get pinController => _pinController;
  GlobalKey get formKey => _formKey;
  bool get otpIsValid => _otpIsValid;

  void setOtpIsValid(bool value) {
    _otpIsValid = value;
    //notifyListeners();
  }
}