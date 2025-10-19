import 'package:convenience_store_food_record_app/theme/custom_texttheme.dart';
import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.terms_of_service_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                l10n.terms_of_service_last_updated,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_one,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_one_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_two,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_two_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_three,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_three_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_four,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_four_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_five,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_five_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_six,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_six_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_seven,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_seven_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_eight,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_eight_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_nine,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_nine_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                l10n.terms_of_service_sentence_ten,
                style: Theme.of(context).textTheme.bodyLargeBold,
              ),
              Text(
                l10n.terms_of_service_sentence_ten_content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
