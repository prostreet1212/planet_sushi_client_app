import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/main/presentation/pages/page1.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:provider/provider.dart';

import '../pages/page2.dart';
import '../pages/page3.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 /* int _currentIndex = 0;
  int _previousIndex = 0;
  List<Widget>  pages= [/*const Page1()*/MenuScreen(), const Page2(), const Page3()];

  void _selectedTab(int index) {
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  // Функция для определения направления анимации
  bool _getTransitionType(int from, int to) {
    if (to > from) {
      // Переход вперёд (слева направо)
      return false;
    } else if (to < from) {
      // Переход назад (справа налево)
      return true;
    } else {
      // Если индекс не изменился - используем стандартную горизонтальную анимацию
      return false;
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    MainScreenState mainScreenState=di.sl<MainScreenState>();
    return ChangeNotifierProvider.value(
      value: di.sl<MainScreenState>(),
      child: Consumer(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
            extendBody: true,
            appBar: AppBar(title: const Text('Планета суши'),),
            //body: pages[_lastIndex],
            body: PageTransitionSwitcher(
              //reverse: _getTransitionType(_previousIndex, _currentIndex),
              reverse: mainScreenState.getTransitionType(),
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal, // Горизонтальная ось
                  fillColor: Colors.transparent,
                  child: child,
                );
              },
              child: mainScreenState.pages[mainScreenState.currentIndex],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              elevation: 0,
              onPressed: () {
                mainScreenState.selectedTab(1);
                //_selectedTab(1);
              },
              child: const Icon(Icons.shopping_basket_rounded),
            ),

            /* bottomNavigationBar: BottomAppBar(
            color: Colors.orange,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5.0,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: BottomNavigationBar(
                //selectedFontSize: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.deepPurple,
                currentIndex: _lastIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                onTap: _selectedTab,
                /*(index) {
                  setState(() {
                    _lastIndex = index;
                  });
                },*/
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(icon: GestureDetector(
                      onTap: null,
                      child: const SizedBox.shrink()), label: 'Корзина'),
                  const BottomNavigationBarItem(icon: Icon(Icons.abc_sharp), label: ''),
                ],
              ),
            ),
          ),*/
            bottomNavigationBar: BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              color: Colors.cyan.shade400,
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: () {
                    _selectedTab(0);
                  },
                ),*/
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28.0),
                        splashColor: Colors.blue.withValues(alpha: 0.3), // Цвет "волны"
                        highlightColor: Colors.blue.withValues(alpha: 0.1),
                        onTap: () {
                          mainScreenState.selectedTab(1);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.one_k_plus,color: mainScreenState.currentIndex==0?Colors.white:Colors.black,),
                            Text('Домой', style: TextStyle(fontSize: 12,color:mainScreenState.currentIndex==0?Colors.white:Colors.black, )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(child: Padding(padding: const EdgeInsets.only(top: 30), child: Text('Корзина',style: TextStyle(fontSize: 12,color:mainScreenState.currentIndex==1?Colors.white:Colors.black, ),))),
                  /*IconButton(
                icon:  Icon(
                  Icons.menu,
                  color:_lastIndex==2?Colors.orange: Colors.black,
                ),
                onPressed: () {
                  _selectedTab(2);
                },
              ),*/
                  SizedBox(
                    height: 58,
                    width: 58,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28.0),
                        splashColor: Colors.blue.withValues(alpha: 0.3), // Цвет "волны"
                        highlightColor: Colors.blue.withValues(alpha: 0.1),
                        onTap: () {
                          mainScreenState.selectedTab(2);

                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.one_k_plus,color: mainScreenState.currentIndex==2?Colors.white:Colors.black,),
                            Text('Отзывы', style: TextStyle(fontSize: 12,color:mainScreenState.currentIndex==2?Colors.white:Colors.black, )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        //child:
      ),
    );
  }
}


