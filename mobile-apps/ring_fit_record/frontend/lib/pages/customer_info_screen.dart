import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_dropdown_button.dart';
import 'package:frontend/models/user_info.dart';
import 'package:frontend/pages/top_screen.dart';

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  // TODO 現在の登録値をセット
  late String _dominantHand = '';
  late String _ringFingerJoint = '';
  late String _frequencyOfRemoval = '';
  late String _sake;
  late String _fitPreference;

  late UserInfo user;

  // TODO 暫定でAPIコールの代わり
  @override
  void initState() {
    super.initState();
    // TODO ここでAPIコール
    user = UserInfo(
      name: 'John Doe',
      ringShape: 'V字',
      material: 'コーラルG',
      size: '12号',
      width: 2.5,
      thickness: 1.7,
      dominantHand: '右手',
      ringFingerJoint: 'あり',
      frequencyOfRemoval: '少ない、外さない',
      sake: 'よく飲む',
      fitPreference: '多少きつめ',
    );

    _dominantHand = user.dominantHand;
    _ringFingerJoint = user.ringFingerJoint;
    _frequencyOfRemoval = user.frequencyOfRemoval;
    _sake = user.sake;
    _fitPreference = user.fitPreference;
  }

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
                l10n.customerInfoScreenTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _createRowItem(
              l10n.customerInfoName,
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoRingShape,
              Text(
                user.ringShape,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoMaterial,
              Text(
                user.material,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoSize,
              Text(
                user.size,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoWidth,
              Text(
                '${user.width}mm',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoThickness,
              Text(
                '${user.thickness}mm',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            _createRowItem(
              l10n.customerInfoDominantHand,
              CustomDropdownButton(
                items: List.of([
                  l10n.dominantHandChoicesRightHand,
                  l10n.dominantHandChoicesLeftHand,
                ]),
                value: _dominantHand,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _dominantHand = value;
                    }
                  });
                },
              ),
            ),
            _createRowItem(
              l10n.customerInfoRingFingerJoint,
              CustomDropdownButton(
                items: List.of([
                  l10n.ringFingerJointChoicesYes,
                  l10n.ringFingerJointChoicesYesALittle,
                  l10n.ringFingerJointChoicesNo,
                ]),
                value: _ringFingerJoint,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _ringFingerJoint = value;
                    }
                  });
                },
              ),
            ),
            _createRowItem(
              l10n.customerInfoFrequencyOfRemoval,
              CustomDropdownButton(
                isExpanded: true,
                items: List.of([
                  l10n.frequencyOfRemovalChoicesMany,
                  l10n.frequencyOfRemovalChoicesSometime,
                  l10n.frequencyOfRemovalChoicesFew,
                ]),
                value: _frequencyOfRemoval,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _frequencyOfRemoval = value;
                    }
                  });
                },
              ),
            ),
            _createRowItem(
              l10n.customerInfoSake,
              CustomDropdownButton(
                items: List.of([
                  l10n.sakeChoicesMany,
                  l10n.sakeChoicesSometime,
                  l10n.sakeChoicesFew,
                ]),
                value: _sake,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _sake = value;
                    }
                  });
                },
              ),
            ),
            _createRowItem(
              l10n.customerInfoFitPreference,
              CustomDropdownButton(
                items: List.of([
                  l10n.fitPreferenceChoicesTight,
                  l10n.fitPreferenceChoicesSomewhatTight,
                  l10n.fitPreferenceChoicesNormal,
                  l10n.fitPreferenceChoicesSlightlyLoose,
                  l10n.fitPreferenceChoicesLoose,
                ]),
                value: _fitPreference,
                onChanged: (String? value) {
                  setState(() {
                    if (value != null) {
                      _fitPreference = value;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TopScreen()));
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

  Widget _createRowItem(String title, Widget widget) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ),
        ],
      ),
    );
  }
}
