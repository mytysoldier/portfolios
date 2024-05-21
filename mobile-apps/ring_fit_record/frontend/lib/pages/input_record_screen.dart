import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO statefulwidgetに変更（画面切り替えがあるため）
class InputRecordScreen extends StatelessWidget {
  const InputRecordScreen({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: Colors.brown,
              alignment: Alignment.center,
              child: Text(
                l10n.inputRecordScreenTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.inputRecordScreenTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              // TODO
              // widget.onSubmit();
            },
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xffFFFFCC),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.buttonTextSave,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }
}
