import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputRecordScreen3 extends ConsumerWidget {
  const InputRecordScreen3({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.brown,
                alignment: Alignment.center,
                child: Text(
                  l10n.inputRecordScreen3Title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 16,
                  children: [
                    Text(
                      l10n.inputRecordScreen3Description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                l10n.buttonTextTempSave,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }
}
