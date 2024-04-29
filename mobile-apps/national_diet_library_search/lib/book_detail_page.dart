import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:isbn/isbn.dart';
import 'package:national_diet_library_search/component/common/loading.dart';
import 'package:national_diet_library_search/model/response/search_api_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.detail});

  final SearchApiResponse detail;

  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  String? isbn13;

  @override
  void initState() {
    super.initState();
    if (widget.detail.isbn != null) {
      Isbn isbn = Isbn();
      setState(() {
        isbn13 = isbn.toIsbn13(widget.detail.isbn!);
      });
    } else {
      setState(() {
        isbn13 = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.book_detail_page_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (() {
          if (isbn13 == null) {
            return const Loading();
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.detail.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.network(
                    'https://ndlsearch.ndl.go.jp/thumbnail/$isbn13.jpg',
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, st) {
                      return SizedBox(
                        height: 200,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error),
                            Text(l10n.image_not_found),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(widget.detail.author),
                  const SizedBox(height: 16),
                  Html(data: widget.detail.description)
                ],
              ),
            );
          }
        })(),
      ),
    );
  }
}
