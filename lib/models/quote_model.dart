// A simple class to represent each quote
class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  // Factory constructor to create Quote from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] ?? 'No text',
      author: json['a'] ?? 'Unknown',
    );
  }
}
