import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputRecordScreen2 extends StatefulWidget {
  const InputRecordScreen2({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  State<StatefulWidget> createState() => _InputRecordScreenState();
}

class _InputRecordScreenState extends State<InputRecordScreen2> {
  final CarouselController _controller = CarouselController();

  String _selectedCondition = '';

  Map<int, String>? _selectionTextMap;

  int _currentPageIndex = 0;

  Widget _createConditionSelection(String selectionText) {
    return ListTile(
      title: Text(
        selectionText,
      ),
      leading: Radio<String>(
        value: selectionText,
        groupValue: _selectedCondition,
        onChanged: (value) {
          setState(() {
            changeSelectionText(value!);
          });
        },
      ),
    );
  }

  // ラジオボタンの切り替え時にカルーセル画像を指定のページ位置まで移動する
  void changeSelectionText(String selectionText) {
    int pageIndex = _selectionTextMap!.entries
        .firstWhere((element) => element.value == selectionText)
        .key;

    _currentPageIndex = pageIndex;
    _controller.animateToPage(pageIndex);
    // ラジオボタンの選択切り替え
    setState(() {
      _selectedCondition = selectionText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    if (_selectedCondition.isEmpty) {
      _selectedCondition = l10n.conditionOfFeelingOfWearingSelection1;
    }

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
                  l10n.inputRecordScreen2Title,
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
                    l10n.inputRecordScreen2Description1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.inputRecordScreen2Description2,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    l10n.inputRecordScreen2Description3,
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
                              'assets/record_of_fit/sensation_at_base_of_finger$i.png',
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
                          if (_currentPageIndex != 0) {
                            _currentPageIndex--;
                            _controller.previousPage();

                            // ラジオボタンの選択切り替え
                            setState(() {
                              _selectedCondition =
                                  _selectionTextMap![_currentPageIndex]!;
                            });
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
                          if (_currentPageIndex != 4) {
                            _currentPageIndex++;
                            _controller.nextPage();

                            // ラジオボタンの選択切り替え
                            setState(() {
                              _selectedCondition =
                                  _selectionTextMap![_currentPageIndex]!;
                            });
                          }
                        },
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  _createConditionSelection(
                      l10n.conditionOfFeelingOfWearingSelection1),
                  _createConditionSelection(
                      l10n.conditionOfFeelingOfWearingSelection2),
                  _createConditionSelection(
                      l10n.conditionOfFeelingOfWearingSelection3),
                  _createConditionSelection(
                      l10n.conditionOfFeelingOfWearingSelection4),
                  _createConditionSelection(
                      l10n.conditionOfFeelingOfWearingSelection5),
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
