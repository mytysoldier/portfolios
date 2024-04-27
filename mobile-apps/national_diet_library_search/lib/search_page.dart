import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:national_diet_library_search/component/search/search_result.dart';
import 'package:national_diet_library_search/model/response/search_api_response.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchApiResponse> results = List.empty();

  Future<void> searchBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      results =
          List.generate(3, (index) => SearchApiResponse(title: 'title$index'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search_page_title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(hintText: l10n.search_book_hint_text),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  await searchBooks();
                },
                child: Text(l10n.search_text)),
            if (results.isNotEmpty)
              Expanded(
                child: SearchResult(results: results),
              ),
          ],
        ),
      ),
    );
  }
}
