
import 'package:flutter/cupertino.dart';

class MainScreenProvider extends ChangeNotifier{
  int _currentIndex = 0;
  int _previousIndex = 0;

  int get currentIndex=>_currentIndex;
  int get previousIndex=>_previousIndex;

  void _selectedTab(int previousIndex, int currentIndex){
    _previousIndex=previousIndex;
    _currentIndex=currentIndex;
  }

}