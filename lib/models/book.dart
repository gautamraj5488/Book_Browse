class Book {
  final String title;
  final String author;
  final String? imageUrl;
  final String? description;

  Book({
    required this.title,
    required this.author,
    this.imageUrl,
    this.description,
  });

  // Convert JSON to Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: json['author'] ?? 'Unknown',
      imageUrl: json['formats'] != null && json['formats']['image/jpeg'] != null
          ? json['formats']['image/jpeg']
          : null,
      description: json['description'] ?? '',
    );
  }
}
