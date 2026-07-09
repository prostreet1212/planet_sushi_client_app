

import 'package:flutter/material.dart';

class NameState extends ChangeNotifier{

  TextEditingController _nameController= TextEditingController();
  bool _nameIsFilled=false;


  TextEditingController get nameController => _nameController;
  bool get nameIsFilled => _nameIsFilled;

  void setNameIsFilled(bool value){
    _nameIsFilled=value;
    notifyListeners();
  }
}