/*import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cart/presentation/pages/cart_page.dart';
import '../../../../shop/presentation/cubits/catalog_cubit/catalog_cubit.dart';
import '../../../../shop/presentation/pages/menu_page/menu_page.dart';
import '../../pages/profile_page.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class MainScreenState extends ChangeNotifier {
  int _currentIndex = 0;
  int _previousIndex = 0;
  List<Widget> pages = [ /*const Page1()*/ MenuPage(), const CartPage(), const ProfilePage()];

  int get currentIndex => _currentIndex;

  int get previousIndex => _previousIndex;

  void selectedTab(int index) {
    _previousIndex = _currentIndex;
    _currentIndex = index;
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
*/
