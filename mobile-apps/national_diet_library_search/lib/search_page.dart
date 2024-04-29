import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:national_diet_library_search/component/search/search_result.dart';
import 'package:national_diet_library_search/model/response/search_api_response.dart';
import 'package:http/http.dart' as http;

import 'package:xml/xml.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchApiResponse> results = List.empty();

  Future<void> searchBooks(String title) async {
    final url = Uri.https(
        'ndlsearch.ndl.go.jp', '/api/opensearch', {'cnt': '2', 'title': title});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final xmlResponse = XmlDocument.parse(response.body);
      debugPrint('xml response: ${xmlResponse}');
      final itemTags = xmlResponse.findAllElements('item');
      debugPrint('itemTags: ${itemTags}');
      // final titles = itemTags
      //     .map((item) => item.findAllElements('title').first.innerText)
      //     .toList();
      final parsedResponse = itemTags
          .map((item) => {
                'title': item.findAllElements('title').first.innerText,
                'author': item.findAllElements('author').first.innerText,
                'description':
                    item.findAllElements('description').first.innerText,
                // ISBNはタグが返ってきたらセット
                'isbn': item
                    .findAllElements('dc:identifier')
                    .where((element) =>
                        element.getAttribute('xsi:type') == 'dcndl:ISBN')
                    .firstOrNull
                    ?.innerText
                    .replaceAll('-', ''),
              })
          .toList();
      debugPrint('parsedResponse: $parsedResponse');
      // final jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      // await Future.delayed(const Duration(milliseconds: 500));
      final resultLists = List.generate(
        parsedResponse.length,
        (index) => SearchApiResponse(
          title: parsedResponse[index]['title']!,
          author: parsedResponse[index]['author']!,
          description: parsedResponse[index]['description']!,
          isbn: parsedResponse[index]['isbn'],
        ),
      );

      setState(() {
        // results = List.generate(
        //     3, (index) => SearchApiResponse(title: 'title$index'));
        results = resultLists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final formKey = GlobalKey<FormState>();

    String formText = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search_page_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.search_text_not_input;
                  }
                  return null;
                },
                onChanged: (value) {
                  formText = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await searchBooks(formText);
                  }
                },
                child: Text(l10n.search_text),
              ),
              if (results.isNotEmpty)
                Expanded(
                  child: SearchResult(results: results),
                ),
            ],
          ),
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     // mainAxisAlignment: MainAxisAlignment.center,
      //     // crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Form(
      //         child: TextFormField(
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return l10n.search_text_not_input;
      //             }
      //             return null;
      //           },
      //         ),
      //       ),
      //       // TextField(
      //       //   decoration: InputDecoration(hintText: l10n.search_book_hint_text),
      //       // ),
      //       const SizedBox(height: 16),
      //       ElevatedButton(
      //         onPressed: () async {
      //           await searchBooks();
      //         },
      //         child: Text(l10n.search_text),
      //       ),
      //       if (results.isNotEmpty)
      //         Expanded(
      //           child: SearchResult(results: results),
      //         ),
      //     ],
      //   ),
      // ),
    );
  }
}
