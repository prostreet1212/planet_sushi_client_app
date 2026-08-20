import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/main_screen_state.dart';

class MainNavFab extends StatelessWidget {
  const MainNavFab({super.key});

  @override
  Widget build(BuildContext context) {
    //final mainScreenState = context.watch<MainScreenState>();
    return Builder(
      builder: (context) {
        final tabsRouter = AutoTabsRouter.of(context);
        return FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0,
          onPressed: () {
            //context.read<MainScreenState>().selectedTab(1);
            tabsRouter.setActiveIndex(1);

          },
          child:  ListenableBuilder(
            listenable: tabsRouter,
            builder: (context, child) {
              final isActive = tabsRouter.activeIndex == 1;
              return Icon(Icons.shopping_basket_rounded,color: /*mainScreenState.currentIndex==1*/isActive?Colors.white:Colors.black,);
            }
          ),
        );
      }
    );
  }
}
