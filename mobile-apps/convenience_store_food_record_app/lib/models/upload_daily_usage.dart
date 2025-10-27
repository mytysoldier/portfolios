class UploadDailyUsage {
  final int userId;
  final DateTime quotaDate;
  final int currentCount;
  final int dailyLimit;
  final DateTime? lastUploadedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UploadDailyUsage({
    required this.userId,
    required this.quotaDate,
    required this.currentCount,
    required this.dailyLimit,
    this.lastUploadedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UploadDailyUsage.fromJson(Map<String, dynamic> json) {
    return UploadDailyUsage(
      userId: json['user_id'] as int,
      quotaDate: _parseDate(json['quota_date']),
      currentCount: json['current_count'] as int,
      dailyLimit: json['daily_limit'] as int,
      lastUploadedAt: _parseNullableDateTime(json['last_uploaded_at']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'quota_date': _formatDate(quotaDate),
      'current_count': currentCount,
      'daily_limit': dailyLimit,
      'last_uploaded_at': lastUploadedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UploadDailyUsage copyWith({
    int? currentCount,
    int? dailyLimit,
    DateTime? lastUploadedAt,
    DateTime? updatedAt,
  }) {
    return UploadDailyUsage(
      userId: userId,
      quotaDate: quotaDate,
      currentCount: currentCount ?? this.currentCount,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      lastUploadedAt: lastUploadedAt ?? this.lastUploadedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    throw ArgumentError('Invalid date value: $value');
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    throw ArgumentError('Invalid datetime value: $value');
  }

  static DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return null;
  }

  static String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}
