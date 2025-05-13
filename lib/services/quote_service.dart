// lib/services/quote_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteService {
  // Fetch quotes from ZenQuotes API
  Future<List<Quote>> fetchQuotes({String? category}) async {
    final url = Uri.parse('https://zenquotes.io/api/quotes'); // ZenQuotes API

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data; // ZenQuotes API directly returns an array of quotes
      return results.map((q) => Quote.fromJson(q)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
