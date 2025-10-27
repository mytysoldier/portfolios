import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/upload_daily_usage.dart';

class UploadDailyUsageNotifier extends StateNotifier<UploadDailyUsage?> {
  UploadDailyUsageNotifier() : super(null);

  static const _tableName = 'upload_daily_usage';

  SupabaseClient get _client => Supabase.instance.client;

  Future<UploadDailyUsage?> fetch({
    required int userId,
    DateTime? quotaDate,
  }) async {
    final targetDate = _formatDate(quotaDate ?? DateTime.now());
    final List<dynamic> response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .eq('quota_date', targetDate);

    if (response.isEmpty) {
      state = null;
      return null;
    }

    final usage = UploadDailyUsage.fromJson(
      Map<String, dynamic>.from(response.first),
    );
    state = usage;
    return usage;
  }

  Future<List<UploadDailyUsage>> fetchHistory({
    required int userId,
    int? limit,
  }) async {
    var query = _client
        .from(_tableName)
        .select()
        .eq('user_id', userId)
        .order('quota_date', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final List<dynamic> response = await query;

    return response
        .map((row) => UploadDailyUsage.fromJson(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<UploadDailyUsage> create({
    required int userId,
    required int dailyLimit,
    int currentCount = 0,
    DateTime? quotaDate,
    DateTime? lastUploadedAt,
  }) async {
    final payload = <String, dynamic>{
      'user_id': userId,
      'quota_date': _formatDate(quotaDate ?? DateTime.now()),
      'current_count': currentCount,
      'daily_limit': dailyLimit,
      if (lastUploadedAt != null)
        'last_uploaded_at': lastUploadedAt.toIso8601String(),
    };

    final data = await _client
        .from(_tableName)
        .insert(payload)
        .select()
        .single();

    final usage = UploadDailyUsage.fromJson(Map<String, dynamic>.from(data));
    state = usage;
    return usage;
  }

  Future<UploadDailyUsage> update({
    required int userId,
    DateTime? quotaDate,
    int? currentCount,
    int? dailyLimit,
    DateTime? lastUploadedAt,
  }) async {
    final payload = <String, dynamic>{
      if (currentCount != null) 'current_count': currentCount,
      if (dailyLimit != null) 'daily_limit': dailyLimit,
      if (lastUploadedAt != null)
        'last_uploaded_at': lastUploadedAt.toIso8601String(),
    };

    if (payload.isEmpty) {
      throw ArgumentError('更新する項目が指定されていません。');
    }

    payload['updated_at'] = DateTime.now().toIso8601String();

    final data = await _client
        .from(_tableName)
        .update(payload)
        .match({
          'user_id': userId,
          'quota_date': _formatDate(quotaDate ?? DateTime.now()),
        })
        .select()
        .single();

    final usage = UploadDailyUsage.fromJson(Map<String, dynamic>.from(data));
    state = usage;
    return usage;
  }

  Future<UploadDailyUsage> incrementCount({
    required int userId,
    required int dailyLimit,
    DateTime? quotaDate,
  }) async {
    final targetDate = quotaDate ?? DateTime.now();
    final existing = await fetch(userId: userId, quotaDate: targetDate);

    if (existing == null) {
      return create(
        userId: userId,
        dailyLimit: dailyLimit,
        currentCount: 1,
        quotaDate: targetDate,
        lastUploadedAt: DateTime.now(),
      );
    }

    final nextCount = existing.currentCount + 1;
    final limitChanged = existing.dailyLimit != dailyLimit;
    final effectiveLimit = limitChanged ? dailyLimit : existing.dailyLimit;

    if (nextCount > effectiveLimit) {
      throw StateError('日次上限を超えるためインクリメントできません。');
    }

    return update(
      userId: userId,
      quotaDate: targetDate,
      currentCount: nextCount,
      dailyLimit: limitChanged ? dailyLimit : null,
      lastUploadedAt: DateTime.now(),
    );
  }

  void clear() {
    state = null;
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}

final uploadDailyUsageProvider =
    StateNotifierProvider<UploadDailyUsageNotifier, UploadDailyUsage?>(
      (ref) => UploadDailyUsageNotifier(),
    );
