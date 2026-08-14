import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('строитель пэйдж3');
    return Container(
      //color: Colors.green,
      child: const Center(
        child: Text('Отзывы'),
      ),
    );
  }
}
