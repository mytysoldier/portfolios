import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/apis/api_service.dart';
import 'package:frontend/components/custom_dropdown_button.dart';
import 'package:frontend/models/user_info.dart';

class CustomerInfoScreen extends StatefulWidget {
  const CustomerInfoScreen({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

  @override
  State<StatefulWidget> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  late String _dominantHand = '';
  late String _ringFingerJoint = '';
  late String _frequencyOfRemoval = '';
  late String _sake = '';
  late String _fitPreference = '';

  late Future<UserInfo> user;

  @override
  void initState() {
    super.initState();
    user = fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final userInfo = snapshot.data!;
          // 画面の入力状態保持変数の初期化
          initializeVariables(userInfo);

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
                      userInfo.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _createRowItem(
                    l10n.customerInfoRingShape,
                    Text(
                      userInfo.ringShape,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _createRowItem(
                    l10n.customerInfoMaterial,
                    Text(
                      userInfo.material,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _createRowItem(
                    l10n.customerInfoSize,
                    Text(
                      userInfo.size,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _createRowItem(
                    l10n.customerInfoWidth,
                    Text(
                      '${userInfo.width}mm',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _createRowItem(
                    l10n.customerInfoThickness,
                    Text(
                      '${userInfo.thickness}mm',
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
                  onTap: () async {
                    try {
                      user = updateUserInfo(UserInfo(
                        name: userInfo.name,
                        ringShape: userInfo.ringShape,
                        material: userInfo.material,
                        size: userInfo.size,
                        width: userInfo.width,
                        thickness: userInfo.thickness,
                        dominantHand: _dominantHand,
                        ringFingerJoint: _ringFingerJoint,
                        frequencyOfRemoval: _frequencyOfRemoval,
                        sake: _sake,
                        fitPreference: _fitPreference,
                      ));
                      // setState(() {
                      //   user = updatedUser;
                      // });
                    } on Exception catch (_, ex) {}
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
      },
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

  void initializeVariables(UserInfo user) {
    if (_dominantHand.isEmpty) {
      _dominantHand = user.dominantHand;
    }
    if (_ringFingerJoint.isEmpty) {
      _ringFingerJoint = user.ringFingerJoint;
    }
    if (_frequencyOfRemoval.isEmpty) {
      _frequencyOfRemoval = user.frequencyOfRemoval;
    }
    if (_sake.isEmpty) {
      _sake = user.sake;
    }
    if (_fitPreference.isEmpty) {
      _fitPreference = user.fitPreference;
    }
  }
}
