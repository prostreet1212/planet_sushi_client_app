import 'package:flutter/material.dart';

/// Блок с накопленными баллами.
class BonusPoints extends StatelessWidget {
  const BonusPoints({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Баллы',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          '$points',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xff07aa55),
          ),
        ),
      ],
    );
  }
}