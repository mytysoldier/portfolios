import 'package:convenience_store_food_record_app/theme/custom_texttheme.dart';
import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacy_policy_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                l10n.privacy_policy_last_updated,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_title,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_one,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_one_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_two,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_two_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_three,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_three_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_four,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_four_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_five,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_five_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_six,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_six_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_seven,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_seven_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.privacy_policy_section_eight,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.privacy_policy_section_eight_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
