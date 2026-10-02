import 'package:flutter/material.dart';

/// Заглушка на время загрузки профиля.
class ProfileLoadingCard extends StatelessWidget {
  const ProfileLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const SizedBox(
        height: 96,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}