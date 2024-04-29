import 'package:flutter/material.dart';
import 'package:national_diet_library_search/book_detail_page.dart';
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
        Text(
          l10n.search_result_text,
          style: const TextStyle(fontSize: 20),
        ),
        Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            final result = results[index];
            return GestureDetector(
              onTap: () {
                // 詳細ページ遷移
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BookDetailPage(detail: result)));
              },
              child: ListTile(
                leading: Text('${index + 1}'),
                title: Text(result.title),
                subtitle: Text(result.author),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 1);
          },
        ))
      ],
    );
  }
}
