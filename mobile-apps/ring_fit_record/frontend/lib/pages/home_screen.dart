import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_appbar.dart';
import 'package:frontend/components/custom_drawer.dart';
import 'package:frontend/pages/customer_info_screen.dart';
import 'package:frontend/pages/top_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.headerLogoTitle,
      ),
      endDrawer: const CustomDrawer(),
      body: const CustomerInfoScreen(),
    );
  }
}
