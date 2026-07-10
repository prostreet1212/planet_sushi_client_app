

import 'package:flutter/material.dart';

class NameState extends ChangeNotifier{

  final TextEditingController _nameController= TextEditingController();
  bool _nameIsFilled=false;
  bool _isPortrait=true;
  double _keyboardHeight=0;
  //String _phone='';


  TextEditingController get nameController => _nameController;
  bool get nameIsFilled => _nameIsFilled;
  bool get isPortrait => _isPortrait;
  double get keyboardHeight => _keyboardHeight;
  //String get phone => _phone;

  void setNameIsFilled(bool value){
    _nameIsFilled=value;
    notifyListeners();
  }

  void setKeyboardHeight(double value){
    _keyboardHeight=value;
    notifyListeners();
  }
  void setIsPortrait(bool value){
    _isPortrait=value;
  }

 /* void setPhone(String value){
    _phone=value;
  }*/
}