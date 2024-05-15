import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Drawer(
      backgroundColor: Colors.brown,
      surfaceTintColor: Colors.white,
      child: ListView(
        children: [
          ListTile(
            title: Container(
              height: 42,
              child: Text(
                l10n.menuTextTop,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              // Do something
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Container(
              height: 42,
              child: Text('Item 1'),
            ),
            onTap: () {
              // Do something
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
