import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO statefulwidgetに変更（画面切り替えがあるため）
class InputRecordScreen extends StatefulWidget {
  const InputRecordScreen({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  State<StatefulWidget> createState() => _InputRecordScreenState();
}

class _InputRecordScreenState extends State<InputRecordScreen> {
  String _selectedCondition = '';

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
            _selectedCondition = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final CarouselController _controller = CarouselController();
    int _currentPageIndex = 0;

    if (_selectedCondition.isEmpty) {
      _selectedCondition = l10n.conditionOfTheKnotsSelection1;
    }

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
                          if (_currentPageIndex != 0) {
                            _currentPageIndex++;
                            _controller.previousPage();
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
