import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/widgets/general_widgets/animated_indexed_stack1.dart';
import 'package:provider/provider.dart';

import 'general_widgets/animated_indexed_stack.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
   /* return Selector<MainScreenState, ({int currentIndex, int previousIndex})>(
        selector: (_, state) =>
        (currentIndex: state.currentIndex, previousIndex: state.previousIndex),
        builder: (context, data, child) {
          final mainScreenState = context.read<MainScreenState>();
          return PageTransitionSwitcher(
            reverse: mainScreenState.getTransitionType(),
            duration: const Duration(milliseconds: 5000),
            transitionBuilder: (Widget child, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                // Горизонтальная ось
                fillColor: Colors.transparent,
                child: child,
              );
            },
            // child: mainScreenState.pages[mainScreenState.currentIndex],было изначально
            child: IndexedStack(
              key: ValueKey(data.currentIndex),
              index: mainScreenState.currentIndex,
              children: mainScreenState.pages,
            ),
          );
        }
    );
  }*/
return Container();
  /*  final state = context.watch<MainScreenState>();
    return AnimatedIndexedStack1(
      index: state.currentIndex,
      children: state.pages,
      duration: Duration(milliseconds: 500),
      curve: Easing.legacy,
    );*/
  }

}

//пробники

// final state = context.watch<MainScreenState>();
// return AnimatedIndexedStack(
//   index: state.currentIndex,
//   previousIndex: state.previousIndex,
//   reverse: state.getTransitionType(),
//   children: state.pages,
//   duration: const Duration(milliseconds: 5000),
// );

