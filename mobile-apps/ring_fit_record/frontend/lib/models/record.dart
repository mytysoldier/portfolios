class Record {
  final String attachment;
  final String comfort;
  final String memo;
  final DateTime createdAt;

  Record({
    required this.attachment,
    required this.comfort,
    required this.memo,
    required this.createdAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = DateTime.parse(json['CreatedAt']);
    return Record(
      attachment: json['Attachment'],
      comfort: json['Comfort'],
      memo: json['Memo'],
      createdAt: createdAt,
    );
  }
}
