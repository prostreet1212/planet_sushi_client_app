import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/main/presentation/screens/providers/main_screen_state.dart';
import 'package:provider/provider.dart';

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MainScreenState,   ({int currentIndex, int previousIndex})>(
      selector:(_, state) =>
      (currentIndex: state.currentIndex, previousIndex: state.previousIndex),
      builder: (context,data,child){
        final mainScreenState = context.read<MainScreenState>();
        return PageTransitionSwitcher(
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
        );
      }
    );
  }
}
