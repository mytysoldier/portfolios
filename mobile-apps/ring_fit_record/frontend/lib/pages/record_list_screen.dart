import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordListScreen extends StatelessWidget {
  const RecordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.brown,
          alignment: Alignment.center,
          child: Text(
            l10n.recordListScreenTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // TODO
        Flexible(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, index) {
              return Text(
                'data',
              );
            },
          ),
        ),
      ],
    );
  }
}
