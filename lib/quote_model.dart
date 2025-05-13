// Quote model class to map JSON data
class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  // Factory method to create Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      content: json['content'],
      author: json['author'],
    );
  }
}
