import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/general_widgets/main_nav_item.dart';
import 'package:provider/provider.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель мэйннавбар');
    // MainScreenState mainScreenState=context.watch<MainScreenState>();
    return BottomAppBar(
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
          const MainNavItem(
            icon: Icons.one_k_plus,
            label: 'Меню',
            tabIndex: 0,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child:Builder(
                  builder: (context) {
                    final tabsRouter = AutoTabsRouter.of(context);
                    return ListenableBuilder(
                        listenable: tabsRouter,
                        builder: (context,  child) {
                          final isActive = tabsRouter.activeIndex == 1;
                          return Text(
                            'Корзина',
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.white : Colors.black,
                            ),
                          );
                        }
                    );
                  }
              ),
              /*Selector<MainScreenState, bool>(
                selector: (context, state) => state.currentIndex == 1,
                builder: (BuildContext context, bool isActive, Widget? child) {
                  return Builder(
                    builder: (context) {
                      final tabsRouter = AutoTabsRouter.of(context);
                      return ListenableBuilder(
                        listenable: tabsRouter,
                        builder: (context,  child) {
                          final isActive = tabsRouter.activeIndex == 1;
                          return Text(
                            'Корзина',
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.white : Colors.black,
                            ),
                          );
                        }
                      );
                    }
                  );
                },
              ),*/
            ),
          ),
          const MainNavItem(
            icon: Icons.person,
            label: 'Профиль',
            tabIndex: 2,
          ),

          /*IconButton(
                icon:  Icon(
                  Icons.menu,
                  color:_lastIndex==2?Colors.orange: Colors.black,
                ),
                onPressed: () {
                  _selectedTab(2);
                },
              ),*/
        ],
      ),
    );
  }
}
