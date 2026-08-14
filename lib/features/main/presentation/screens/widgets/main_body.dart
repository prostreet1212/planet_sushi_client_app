import 'package:animations/animations.dart';
import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:provider/provider.dart';

import 'general_widgets/animated_indexed_stack.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MainScreenState,   ({int currentIndex, int previousIndex})>(
      selector:(_, state) =>
      (currentIndex: state.currentIndex, previousIndex: state.previousIndex),
      builder: (context,data,child){
        final mainScreenState = context.read<MainScreenState>();
        // return EasyAnimatedIndexedStack(
        //   skipEnd: true,
        //   index: mainScreenState.currentIndex,
        //   duration: const Duration(milliseconds: 500),
        //   animationBuilder: (context, animation, child) {
        //     return Opacity(
        //       opacity: animation.value,
        //       child: Transform.translate(
        //         offset: Offset((1 - animation.value) * 10,0 ),
        //         child: child,
        //       ),
        //     );
        //   },
        //   children:  mainScreenState.pages,
        // );
        return PageTransitionSwitcher(
          reverse: mainScreenState.getTransitionType(),
          duration: const Duration(milliseconds: 5000),
          transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal, // Горизонтальная ось
              fillColor: Colors.transparent,
              child: child,
            );
          },
          // child: mainScreenState.pages[mainScreenState.currentIndex],
          child: IndexedStack(
           key: ValueKey(data.currentIndex),
            index: mainScreenState.currentIndex,
            children: mainScreenState.pages,
          ),
        );
      }
    );
    /*final state = context.watch<MainScreenState>();
    return AnimatedIndexedStack(
      index: state.currentIndex,
      previousIndex: state.previousIndex,
      reverse: state.getTransitionType(),
      children: state.pages,
      duration: const Duration(milliseconds: 5000),
    );*/
  }
}
