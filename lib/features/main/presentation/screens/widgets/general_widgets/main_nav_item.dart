import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/main_screen_state.dart';


class MainNavItem extends StatelessWidget {
  const MainNavItem({super.key, required this.icon, required this.label, required this.tabIndex});

  final IconData icon;
  final String label;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
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
            //mainScreenState.selectedTab(0);
            context.read<MainScreenState>().selectedTab(tabIndex);
          },
          child: Selector<MainScreenState,int>(
            selector: (_,state)=>state.currentIndex,
              builder: (_,currentIndex,_){
                final isActive = currentIndex == tabIndex;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,color: isActive?Colors.white:Colors.black,),
                  Text(label, style: TextStyle(fontSize: 12,color:isActive?Colors.white:Colors.black, )),
                ],
              );
              },
          )
        ),
      ),
    );
  }
}
