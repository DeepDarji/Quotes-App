// lib/models/quote_model.dart

class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  // Create a Quote object from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      content: json['q'], // Content is under 'q' in ZenQuotes
      author: json['a'], // Author is under 'a' in ZenQuotes
    );
  }
}
