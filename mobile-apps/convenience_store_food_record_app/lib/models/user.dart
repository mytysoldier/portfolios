class User {
  final int id; // 主キー
  final String? userName; // ユーザー名
  final String? password; // パスワード
  final String? deviceId; // デバイスID（未登録ユーザー用）
  final DateTime? createdAt; // 作成日時
  final DateTime? updatedAt; // 更新日時
  final DateTime? deletedAt; // 削除日時

  User({
    required this.id,
    this.userName,
    this.password,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userName: json['user_name'] as String?,
      password: json['password'] as String?,
      deviceId: json['device_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'password': password,
      'device_id': deviceId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
