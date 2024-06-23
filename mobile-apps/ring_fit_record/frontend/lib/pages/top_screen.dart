import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_buttton.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({
    super.key,
    required this.onKeepRecordButtonPressed,
    required this.onRecordListButtonPressed,
    this.onAnalysisResultButtonPressed,
  });

  final VoidCallback onKeepRecordButtonPressed;
  final VoidCallback onRecordListButtonPressed;
  final VoidCallback? onAnalysisResultButtonPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.brown,
            alignment: Alignment.center,
            child: Text(
              l10n.topScreenTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.topScreenMainText,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            l10n.topScreenMainTextHelp,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 300,
            alignment: Alignment.center,
            child: Text(
              l10n.topScreenSubText,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _createCustomButton(
                l10n.buttonTextKeepRecord,
                onKeepRecordButtonPressed,
              ),
              _createCustomButton(
                l10n.buttonTextRecordList,
                onRecordListButtonPressed,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Image.asset(
            'assets/sinrosinpu.png',
            height: 350,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Container(
            height: 12,
            color: Colors.brown,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.topScreenDescription1),
                Text(l10n.topScreenDescription2),
                Text(l10n.topScreenDescription3),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _createCustomButton(String title, VoidCallback onButtonPressed) {
    return CustomButton(
      title: title,
      size: const Size(double.infinity, 90),
      onButtonPressed: onButtonPressed,
    );
  }
}
