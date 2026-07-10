import 'package:flutter/cupertino.dart';

class OtpPhoneState extends ChangeNotifier{
  String _phone='';

  String get phone => _phone;

  void setPhone(String value){
    _phone=value;
  }
}