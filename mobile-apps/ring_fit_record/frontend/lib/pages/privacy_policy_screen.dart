import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [Text('data')],
      ),
    );
  }
}
