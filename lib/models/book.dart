class Book {
  final int id;
  final String title;
  final List<String> authors;
  final List<String> translators;
  final List<String> subjects;
  final List<String> bookshelves;
  final List<String> languages;
  final bool copyright;
  final String mediaType;
  final Map<String, String> formats;
  final int downloadCount;
  final String? imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.translators,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
    this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      authors: (json['authors'] as List?)
              ?.map((author) => author['name'] as String)
              .toList() ??
          [],
      translators: (json['translators'] as List?)
              ?.map((translator) => translator.toString())
              .toList() ??
          [],
      subjects: (json['subjects'] as List?)?.cast<String>() ?? [],
      bookshelves: (json['bookshelves'] as List?)?.cast<String>() ?? [],
      languages: (json['languages'] as List?)?.cast<String>() ?? [],
      copyright: json['copyright'] ?? false,
      mediaType: json['media_type'] ?? 'Unknown Media Type',
      formats: (json['formats'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as String)),
      downloadCount: json['download_count'] ?? 0,
      imageUrl: json['formats']?['image/jpeg'],
    );
  }
}
