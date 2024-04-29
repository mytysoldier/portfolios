class SearchApiResponse {
  final String title;
  final String author;
  final String description;
  final String? isbn;

  const SearchApiResponse({
    required this.title,
    required this.author,
    required this.description,
    this.isbn,
  });

  // factory SearchApiResponse.fromJson(Map<String>) {}
}
