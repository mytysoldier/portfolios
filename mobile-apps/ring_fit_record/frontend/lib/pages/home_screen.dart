import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/components/custom_appbar.dart';
import 'package:frontend/components/custom_drawer.dart';
import 'package:frontend/constants/page_type.dart';
import 'package:frontend/pages/customer_info_screen.dart';
import 'package:frontend/pages/input_record_screen1.dart';
import 'package:frontend/pages/input_record_screen2.dart';
import 'package:frontend/pages/input_record_screen3.dart';
import 'package:frontend/pages/privacy_policy_screen.dart';
import 'package:frontend/pages/record_detail_screen.dart';
import 'package:frontend/pages/record_list_screen.dart';
import 'package:frontend/pages/top_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageType? pageType;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    pageType ??= PageType.TOP;

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
            pageType = PageType.INPUT_RECORD1;
          });
        },
        onRecordListSelected: () {
          setState(() {
            pageType = PageType.RECORD_LIST;
          });
        },
        onPrivacyPolicySelected: () {
          setState(() {
            pageType = PageType.PRIVACY_POLICY;
          });
        },
      ),
      body: _changeScreen(pageType!, () {
        setState(() {
          pageType = PageType.TOP;
        });
      }),
    );
  }

  Widget _changeScreen(PageType updatePageType, VoidCallback? onSubmit) {
    switch (updatePageType) {
      case PageType.TOP:
        return TopScreen(
          onKeepRecordButtonPressed: () {
            setState(() {
              pageType = PageType.INPUT_RECORD1;
            });
          },
          onRecordListButtonPressed: () {
            setState(() {
              pageType = PageType.RECORD_LIST;
            });
          },
        );
      case PageType.EDIT_CUSTOMER_INFO:
        return CustomerInfoScreen(
          onSubmit: onSubmit!,
        );
      case PageType.INPUT_RECORD1:
        // TOOD あとで戻す
        return InputRecordScreen3(
          onSubmit: () {
            setState(() {
              pageType = PageType.RECORD_DETAIL;
            });
          },
        );
      case PageType.RECORD_LIST:
        return RecordListScreen(
          onRecordTapped: () {
            setState(() {
              pageType = PageType.RECORD_DETAIL;
            });
          },
        );
      case PageType.RECORD_DETAIL:
        return RecordDetailScreen(
          onRecordListTapped: () {
            setState(() {
              pageType = PageType.RECORD_LIST;
            });
          },
        );
      case PageType.PRIVACY_POLICY:
        return const PrivacyPolicyScreen();
      default:
        return Container();
    }
  }
}
