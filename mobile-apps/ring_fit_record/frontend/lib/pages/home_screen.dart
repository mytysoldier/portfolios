import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_appbar.dart';
import 'package:frontend/components/custom_drawer.dart';
import 'package:frontend/constants/page_type.dart';
import 'package:frontend/pages/customer_info_screen.dart';
import 'package:frontend/pages/input_record_screen1.dart';
import 'package:frontend/pages/input_record_screen2.dart';
import 'package:frontend/pages/record_list_screen.dart';
import 'package:frontend/pages/top_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   final l10n = L10n.of(context);

  //   return Scaffold(
  //     appBar: CustomAppBar(
  //       title: l10n.headerLogoTitle,
  //     ),
  //     endDrawer: const CustomDrawer(),
  //     body: const CustomerInfoScreen(),
  //   );
  // }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageType pageType = PageType.TOP;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.headerLogoTitle,
      ),
      endDrawer: CustomDrawer(
        onTopSelected: () {
          setState(
            () {
              pageType = PageType.TOP;
            },
          );
        },
        onEditCustomerInfoSelected: () {
          setState(
            () {
              pageType = PageType.EDIT_CUSTOMER_INFO;
            },
          );
        },
        onInputRecordSelected: () {
          setState(() {
            pageType = PageType.INPUT_RECORD;
          });
        },
        onRecordListSelected: () {
          setState(() {
            pageType = PageType.RECORD_LIST;
          });
        },
      ),
      body: _changeScreen(pageType, () {
        setState(() {
          pageType = PageType.TOP;
        });
      }),
    );
  }

  Widget _changeScreen(PageType pageType, VoidCallback? onSubmit) {
    switch (pageType) {
      case PageType.TOP:
        return const TopScreen();
      case PageType.EDIT_CUSTOMER_INFO:
        return CustomerInfoScreen(
          onSubmit: onSubmit!,
        );
      // TOOD あとで戻す
      case PageType.INPUT_RECORD:
        return InputRecordScreen2(
          onSubmit: onSubmit!,
        );
      case PageType.RECORD_LIST:
        return const RecordListScreen();
      default:
        return Container();
    }
  }
}
