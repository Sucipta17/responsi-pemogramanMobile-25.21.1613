/// Model catatan kuliah.
///
/// Metadata (id, judul, tanggal) disimpan di SharedPreferences,
/// sedangkan [content] disimpan terenkripsi di secure storage.
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  /// JSON metadata saja (TANPA isi catatan).
  Map<String, dynamic> toMetaJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
      };

  /// Membuat [Note] dari metadata + isi catatan.
  factory Note.fromMeta(Map<String, dynamic> json, String content) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: content,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
