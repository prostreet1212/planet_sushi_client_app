import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../core/routers/app_router.dart';
import '../../providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;


class MainNavItem extends StatelessWidget {
  const MainNavItem({super.key, required this.icon, required this.label, required this.tabIndex});

  final IconData icon;
  final String label;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(28.0),
          splashColor: Colors.blue.withValues(alpha: 0.3), // Цвет "волны"
          highlightColor: Colors.blue.withValues(alpha: 0.1),
          onTap: () {
           // mainScreenState.selectedTab(0);
            //context.read<MainScreenState>().selectedTab(tabIndex);
            final isAuthenticated =
                di.sl<Supabase>().client.auth.currentUser?.id != null;
            if (tabIndex == 2 && !isAuthenticated) {
              // Не авторизован → открываем логин, вкладку не переключаем
              context.router.push(const LoginRoute());
              //tabsRouter.setActiveIndex(tabIndex);
            }else{
              tabsRouter.setActiveIndex(tabIndex);
            }



          },
          child: ListenableBuilder(
              listenable: tabsRouter,
              builder: (context, child) {
                final isActive = tabsRouter.activeIndex == tabIndex;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,color: isActive?Colors.white:Colors.black,),
                    Text(label, style: TextStyle(fontSize: 12,color:isActive?Colors.white:Colors.black, )),
                  ],
                );
              }
          )
          /* Selector<MainScreenState,int>(
            selector: (_,state)=>state.currentIndex,
              builder: (_,currentIndex,_){
               // final isActive = currentIndex == tabIndex;
              return ListenableBuilder(
                listenable: tabsRouter,
                builder: (context, child) {
                  final isActive = tabsRouter.activeIndex == tabIndex;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,color: isActive?Colors.white:Colors.black,),
                      Text(label, style: TextStyle(fontSize: 12,color:isActive?Colors.white:Colors.black, )),
                    ],
                  );
                }
              );
              },
          )*/
        ),
      ),
    );
  }
}
