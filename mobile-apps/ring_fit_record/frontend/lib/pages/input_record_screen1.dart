import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/input_record_provider.dart';

final CarouselController _controller = CarouselController();
String _selectedCondition = '';

Map<int, String>? _selectionTextMap;

int _currentPageIndex = 0;

// 現在選択中のカルーセルページ状態管理
final currentPageIndexProvider = StateProvider((ref) => 0);

// 現在選択中のラジオボタン状態管理
final selectedConditionProvider = StateProvider((ref) => '');

class InputRecordScreen1 extends ConsumerWidget {
  const InputRecordScreen1({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);

    final currentPageIndex = ref.watch(currentPageIndexProvider);

    final selectedCondition = ref.watch(selectedConditionProvider);

    // 状態管理している登録レコードの状態
    final inputRecord = ref.watch(inputRecordProvider);

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
      0: l10n.conditionOfTheKnotsSelection1,
      1: l10n.conditionOfTheKnotsSelection2,
      2: l10n.conditionOfTheKnotsSelection3,
      3: l10n.conditionOfTheKnotsSelection4,
      4: l10n.conditionOfTheKnotsSelection5,
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
                  l10n.inputRecordScreenTitle,
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
                    l10n.inputRecordScreenDescription1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.inputRecordScreenDescription2,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    l10n.inputRecordScreenDescription3,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            _currentPageIndex = index;
                          },
                        ),
                        items: [1, 2, 3, 4, 5].map((i) {
                          return Builder(builder: (BuildContext context) {
                            return Image.asset(
                              'assets/record_of_putting_on_and_taking_off/condition_of_knots_$i.png',
                            );
                          });
                        }).toList(),
                        carouselController: _controller,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          // 最初のページ以外であればページを戻る
                          // if (_currentPageIndex != 0) {
                          //   _currentPageIndex--;
                          //   _controller.previousPage();

                          //   // ラジオボタンの選択切り替え
                          //   // setState(() {
                          //   //   _selectedCondition =
                          //   //       _selectionTextMap![_currentPageIndex]!;
                          //   // });
                          // }
                          if (currentPageIndex != 0) {
                            ref.read(currentPageIndexProvider.notifier).state =
                                currentPageIndex - 1;
                            _controller.previousPage();

                            // ラジオボタンの選択切り替え
                            ref.read(selectedConditionProvider.notifier).state =
                                _selectionTextMap![currentPageIndex - 1]!;
                            // setState(() {
                            //   _selectedCondition =
                            //       _selectionTextMap![_currentPageIndex]!;
                            // });
                          }
                        },
                        icon: const Icon(Icons.arrow_left),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          // 最後のページ以外であればページを進む
                          // if (_currentPageIndex != 4) {
                          //   _currentPageIndex++;
                          //   _controller.nextPage();

                          //   // ラジオボタンの選択切り替え
                          //   // setState(() {
                          //   //   _selectedCondition =
                          //   //       _selectionTextMap![_currentPageIndex]!;
                          //   // });
                          // }
                          // 最後のページ以外であればページを進む
                          if (currentPageIndex != 4) {
                            ref.read(currentPageIndexProvider.notifier).state =
                                currentPageIndex + 1;
                            _controller.nextPage();
                            // ラジオボタンの選択切り替え
                            ref.read(selectedConditionProvider.notifier).state =
                                _selectionTextMap![currentPageIndex + 1]!;
                          }
                          //   // ラジオボタンの選択切り替え
                          // setState(() {
                          //   _selectedCondition =
                          //       _selectionTextMap![_currentPageIndex]!;
                          // });
                          // ref.read(selectedConditionProvider.notifier).state =
                          //     _selectionTextMap![currentPageIndex]!;
                        },
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  _createConditionSelection(l10n.conditionOfTheKnotsSelection1),
                  _createConditionSelection(l10n.conditionOfTheKnotsSelection2),
                  _createConditionSelection(l10n.conditionOfTheKnotsSelection3),
                  _createConditionSelection(l10n.conditionOfTheKnotsSelection4),
                  _createConditionSelection(l10n.conditionOfTheKnotsSelection5),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    // TODO
                    // widget.onSubmit();
                    onSubmit();
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
