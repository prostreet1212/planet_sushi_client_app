import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/bonus_points.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/pages/profile_page/widgets/profile_avatar.dart';

import '../../../../../auth/data/models/user_model.dart';

/// Карточка профиля: аватар, имя, телефон и баллы.
class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Row(
              children: [
                ProfileAvatar(avatarUrl: user.avatarUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.phone,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                // Отступ, чтобы текст не заходил под блок с баллами.
                const SizedBox(width: 72),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: BonusPoints(points: user.bonusPoints),
            ),
          ],
        ),
      ),
    );
  }
}