class UserModel {
  final String? id;
  final String phone;
  final String? name;

  //final String? email;
  final String? avatarUrl;

  //final int bonusPoints;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.phone,
    required this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      //bonusPoints: (json['bonus_points'] as num?)?.toInt() ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final now = DateTime.now().toUtc().toIso8601String();
    return {
      if (id != null) 'id': id,
      'phone': phone,
      'name': name,
      'avatar_url': avatarUrl,
      //'bonus_points': bonusPoints,
      'updated_at': updatedAt?.toUtc().toIso8601String() ?? now,
    };
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? avatarUrl,
    int? bonusPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      //bonusPoints: bonusPoints ?? this.bonusPoints,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
