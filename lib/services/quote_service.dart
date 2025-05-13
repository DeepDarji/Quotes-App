import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteService {
  static const String _baseUrl = 'https://zenquotes.io/api/quotes';

  // Fetch quotes from the API
  static Future<List<Quote>> fetchQuotes() async {
    final url = Uri.parse(_baseUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((jsonItem) => Quote.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
