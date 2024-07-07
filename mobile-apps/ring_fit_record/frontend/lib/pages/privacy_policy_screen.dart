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
      child: SingleChildScrollView(
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
              _createSubsentence1(l10n),
              _createSubsentence2(l10n),
              _createSubsentence3(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSubsentence1(L10n l10n) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            l10n.privacyPolicySubSentence1Title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(l10n.privacyPolicySubSentence1Text1),
          Text(l10n.privacyPolicySubSentence1Text2),
          Text(l10n.privacyPolicySubSentence1Text3),
          Text(l10n.privacyPolicySubSentence1Text4),
          Text(l10n.privacyPolicySubSentence1Text5),
          Text(l10n.privacyPolicySubSentence1Text6),
          Text(l10n.privacyPolicySubSentence1Text7),
        ],
      ),
    );
  }

  Widget _createSubsentence2(L10n l10n) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            l10n.privacyPolicySubSentence2Title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(l10n.privacyPolicySubSentence2Text1),
          Text(l10n.privacyPolicySubSentence2Text2),
        ],
      ),
    );
  }

  Widget _createSubsentence3(L10n l10n) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            l10n.privacyPolicySubSentence3Title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(l10n.privacyPolicySubSentence3Text1),
          Text(l10n.privacyPolicySubSentence3Text2),
        ],
      ),
    );
  }
}
