import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/main_screen_state.dart';

class MainNavFab extends StatelessWidget {
  const MainNavFab({super.key});

  @override
  Widget build(BuildContext context) {
    final mainScreenState = context.watch<MainScreenState>();
    return FloatingActionButton(
      shape: const CircleBorder(),
      elevation: 0,
      onPressed: () {
        context.read<MainScreenState>().selectedTab(1);
        //mainScreenState.selectedTab(1);
      },
      child:  Icon(Icons.shopping_basket_rounded,color: mainScreenState.currentIndex==1?Colors.white:Colors.black,),
    );
  }
}
