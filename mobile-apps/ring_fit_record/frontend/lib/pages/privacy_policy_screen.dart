import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.privacyPolicyScreenTitle,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(
              height: 32,
              width: 30,
              child: Divider(
                color: Colors.brown,
              ),
            ),
            Text(l10n.privacyPolicyMainSentenceTitle),
            const SizedBox(height: 5),
            Text(
              l10n.privacyPolicyMainSentenceText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
