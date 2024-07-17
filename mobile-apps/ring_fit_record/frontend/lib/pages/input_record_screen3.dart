import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CarouselController _controller = CarouselController();
String _selectedCondition = '';

Map<int, String>? _selectionTextMap;

int _currentPageIndex = 0;

// 現在選択中のカルーセルページ状態管理
final currentPageIndexProvider = StateProvider((ref) => 0);

// 現在選択中のラジオボタン状態管理
final selectedConditionProvider = StateProvider((ref) => '');

class InputRecordScreen3 extends ConsumerWidget {
  const InputRecordScreen3({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    final currentPageIndex = ref.watch(currentPageIndexProvider);

    final selectedCondition = ref.watch(selectedConditionProvider);

    Future.microtask(() {
      if (selectedCondition.isEmpty) {
        ref.read(selectedConditionProvider.notifier).state =
            l10n.conditionOfTheKnotsSelection1;
      }
    });

    if (_selectedCondition.isEmpty) {
      _selectedCondition = l10n.conditionOfTheKnotsSelection1;
    }

    // ラジオボタンの切り替え時にカルーセル画像を指定のページ位置まで移動する
    void changeSelectionText(String selectionText) {
      int pageIndex = _selectionTextMap!.entries
          .firstWhere((element) => element.value == selectionText)
          .key;

      // _currentPageIndex = pageIndex;
      ref.read(currentPageIndexProvider.notifier).state = pageIndex;
      _controller.animateToPage(pageIndex);
      // ラジオボタンの選択切り替え
      ref.read(selectedConditionProvider.notifier).state = selectionText;
    }

    Widget _createConditionSelection(String selectionText) {
      return ListTile(
        title: Text(
          selectionText,
        ),
        leading: Radio<String>(
          value: selectionText,
          groupValue: selectedCondition,
          onChanged: (value) {
            changeSelectionText(value!);
          },
        ),
      );
    }

    // if (selectedCondition.isEmpty) {
    //   ref.read(selectedConditionProvider.notifier).state =
    //       l10n.conditionOfTheKnotsSelection1;
    //   // _selectedCondition = l10n.conditionOfTheKnotsSelection1;
    // }

    _selectionTextMap ??= {
      0: l10n.conditionOfFeelingOfWearingSelection1,
      1: l10n.conditionOfFeelingOfWearingSelection2,
      2: l10n.conditionOfFeelingOfWearingSelection3,
      3: l10n.conditionOfFeelingOfWearingSelection4,
      4: l10n.conditionOfFeelingOfWearingSelection5,
    };

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
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
              Wrap(
                children: [
                  Text(
                    l10n.inputRecordScreen3Description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                      l10n.buttonTextTempSave,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
