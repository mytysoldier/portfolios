import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/pages/top_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.onTopSelected,
    required this.onEditCustomerInfoSelected,
  });

  final VoidCallback onTopSelected;
  final VoidCallback onEditCustomerInfoSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final navState = Navigator.of(context);

    return Drawer(
      backgroundColor: Colors.brown,
      surfaceTintColor: Colors.white,
      width: 200,
      child: ListView(
        children: [
          _createDrawerMenu(l10n.menuTextTop, () {
            navState.pop();
            onTopSelected();
            // navState.push(
            //     MaterialPageRoute(builder: (context) => const TopScreen()));
          }),
          _createDrawerMenu(l10n.menuTextEditCustomerInfo, () {
            navState.pop();
            onEditCustomerInfoSelected();
            // navState.push(
            //     MaterialPageRoute(builder: (context) => const TopScreen()));
          }),
          _createDrawerMenu(l10n.menuTextInputRecord, () {}),
          _createDrawerMenu(l10n.menuTextRecordList, () {}),
          _createDrawerMenu(l10n.menuTextAnalysisResult, () {}),
          _createDrawerMenu(l10n.menuTextPrivacyPolicy, () {}),
          _createDrawerMenu(l10n.menuTextLogout, () {}),
        ],
      ),
    );
  }

  Widget _createDrawerMenu(
    String title,
    void Function()? onTap,
  ) {
    return SizedBox(
      height: 48,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
