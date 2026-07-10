
import 'package:flutter/cupertino.dart';

import '../../pages/page1.dart';
import '../../pages/page2.dart';
import '../../pages/page3.dart';

class MainScreenState extends ChangeNotifier{
  int _currentIndex = 0;
  int _previousIndex = 0;
  List<Widget>  pages= [/*const Page1()*/MenuScreen(), const Page2(), const Page3()];

  int get currentIndex=>_currentIndex;
  int get previousIndex=>_previousIndex;

  void selectedTab(int index){
    _previousIndex=_currentIndex;
    _currentIndex=index;
    notifyListeners();
  }

  // Функция для определения направления анимации
  bool getTransitionType() {
    if (_currentIndex > _previousIndex) {
      // Переход вперёд (слева направо)
      return false;
    } else if (_currentIndex < _previousIndex) {
      // Переход назад (справа налево)
      return true;
    } else {
      // Если индекс не изменился - используем стандартную горизонтальную анимацию
      return false;
    }

  }

}