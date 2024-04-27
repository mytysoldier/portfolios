import 'package:flutter/material.dart';
import 'package:national_diet_library_search/model/response/search_api_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, required this.results});

  final List<SearchApiResponse> results;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.search_result_text),
        Expanded(
            child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(results[index].title),
            );
          },
        ))
      ],
    );
  }
}
