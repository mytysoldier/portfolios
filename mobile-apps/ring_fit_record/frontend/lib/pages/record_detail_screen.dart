import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/api_service.dart';
import 'package:frontend/models/record.dart';
import 'package:frontend/providers/record_detail_provider.dart';
import 'package:intl/intl.dart';

class RecordDetailScreen extends ConsumerWidget {
  const RecordDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    final record = ref.watch(recordDetailProvider);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.brown,
          alignment: Alignment.center,
          child: Text(
            l10n.recordDetailScreenTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
