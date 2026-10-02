import 'package:flutter/material.dart';

/// Круглый аватар пользователя.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final String url = avatarUrl ?? '';
    final bool hasImage = url.isNotEmpty;

    return CircleAvatar(
      radius: 32,
      backgroundColor: const Color(0xff07aa55).withValues(alpha: 0.15),
      backgroundImage: hasImage ? NetworkImage(url) : null,
      child: hasImage
          ? null
          : const Icon(Icons.person, size: 36, color: Color(0xff07aa55)),
    );
  }
}