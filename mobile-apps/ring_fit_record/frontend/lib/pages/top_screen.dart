import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_appbar.dart';
import 'package:frontend/components/custom_buttton.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

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
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // Text(
          //   l10n.topScreenTitle,
          //   style: const TextStyle(
          //       color: Colors.white, backgroundColor: Colors.brown),
          // ),
          const SizedBox(height: 32),
          Text(l10n.topScreenMainText),
          Text(l10n.topScreenMainTextHelp),
          const SizedBox(height: 32),
          Text(l10n.topScreenSubText),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _createCustomButton(l10n.buttonTextKeepRecord),
              _createCustomButton(l10n.buttonTextRecordList),
              _createCustomButton(l10n.buttonTextAnalysisResult),
            ],
          ),
          Image.asset('assets/sinrosinpu.jpeg'),
          Container(
            height: 12,
            color: Colors.red,
          ),
          Text(l10n.topScreenDescription1),
          Text(l10n.topScreenDescription2),
          Text(l10n.topScreenDescription3),
        ],
      ),
    );
  }

  Widget _createCustomButton(String title) {
    return CustomButton(
      title: title,
      size: Size(double.infinity, 90),
    );
  }
}
