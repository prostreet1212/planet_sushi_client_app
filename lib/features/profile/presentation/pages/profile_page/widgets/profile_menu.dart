import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/profile_menu_item.dart';

/// Меню профиля.
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'История заказов',
            onTap: () {
              // TODO: перейти к истории заказов.
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.favorite_border,
            title: 'Избранное',
            onTap: () {
              // TODO: перейти к избранному.
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Выйти из аккаунта',
            color: Colors.red,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}