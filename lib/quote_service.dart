import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote_model.dart';

class QuoteService {
  static Future<List<Quote>> fetchQuotes() async {
    final url = Uri.parse('http://api.quotable.io/quotes?limit=10');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Map JSON list to List<Quote>
      List quotesList = data['results'];
      return quotesList.map((q) => Quote.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
