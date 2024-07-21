import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputRecordScreen5 extends ConsumerWidget {
  const InputRecordScreen5({
    super.key,
    required this.onPageBack,
  });

  final VoidCallback onPageBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 32),
              // TODO 記録したか記録しなかったかで表示を制御する
              Container(
                height: 92,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(l10n.inputRecordScreen5TextRecordSave),
                    // TODO 記録日時はProviderから取得する
                    Text(l10n.inputRecordScreen5TextRecordSave),
                  ],
                ),
              ),
              Image.asset(
                'assets/record_regist/happy_wedding.png',
                height: 350,
                fit: BoxFit.contain,
              ),
              Text(l10n.inputRecordScreen5Description)
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              // TODO
              // widget.onSubmit();
              onPageBack();
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
                l10n.buttonTextReturnToTop,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    );
  }
}
