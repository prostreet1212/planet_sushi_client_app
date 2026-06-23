import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginState extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final MaskTextInputFormatter phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _sendCodeEnabled = false;
  bool _isPortrait=true;
   BoxConstraints _constraints = BoxConstraints();
   double _keyboardHeight=0;


  bool get sendCodeEnabled => _sendCodeEnabled;
  bool get isPortrait => _isPortrait;
  double get keyboardHeight => _keyboardHeight;
  BoxConstraints get constraints => _constraints;

  void updateSendCodeEnabled(bool value) {
    _sendCodeEnabled = value;
    notifyListeners();
  }

  void updateSizes(bool isPortrait,BoxConstraints constraints,double keyboardHeight) {
    _isPortrait = isPortrait;
    _constraints=constraints;
    _keyboardHeight=keyboardHeight;
  }


  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}