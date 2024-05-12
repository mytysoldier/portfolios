import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_dropdown_button.dart';

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  // TODO 現在の登録値をセット
  String _dominantHand = 'a';

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.brown,
            alignment: Alignment.center,
            child: Text(
              l10n.customerInfoScreenTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _createRowItem(l10n.customerInfoName, Text('data')),
          _createRowItem(
            l10n.customerInfoDominantHand,
            CustomDropdownButton(
              items: List.of(['a', 'b']),
              value: _dominantHand,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) {
                    _dominantHand = value;
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createRowItem(String title, Widget widget) {
    return Row(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title),
        widget,
      ],
    );
  }
}
