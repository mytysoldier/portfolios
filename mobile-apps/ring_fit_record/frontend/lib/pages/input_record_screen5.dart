import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputRecordScreen4 extends ConsumerWidget {
  const InputRecordScreen4({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    Widget createRowContent(
        String title, String value, VoidCallback onEditTapped) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    // color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onEditTapped,
            child: Text(
              l10n.buttonTextEdit,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
        ],
      );
    }

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
                l10n.inputRecordScreen4Title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // TODO Providerから取得する
                  createRowContent(l10n.inputRecordScreen4Item1, 'aa', () {}),
                  const SizedBox(height: 24),
                  // TODO Providerから取得する
                  createRowContent(l10n.inputRecordScreen4Item2, 'aa', () {}),
                  const SizedBox(height: 24),
                  // TODO Providerから取得する
                  createRowContent(l10n.inputRecordScreen4Item3, 'aa', () {})
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO
                    // widget.onSubmit();
                  },
                  child: Container(
                    // width: double.infinity,
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
                      l10n.buttonTextRecordSave,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO
                    // widget.onSubmit();
                  },
                  child: Container(
                    // width: double.infinity,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xffEEEEEE),
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        left: BorderSide(
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
                      l10n.buttonTextRecordNotSave,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
