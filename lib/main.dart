import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart'; // Add share_plus in pubspec.yaml

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Root of the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivational Quotes',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: QuotesHomePage(),
    );
  }
}

class Quote {
  // Simple model to hold a quote
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class QuotesHomePage extends StatefulWidget {
  @override
  _QuotesHomePageState createState() => _QuotesHomePageState();
}

class _QuotesHomePageState extends State<QuotesHomePage> {
  List<Quote> _quotes = [];
  bool _isLoading = false;

  // Fetch quotes from the API
  Future<void> fetchQuotes() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://zenquotes.io/api/quotes');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final quotes = data.map((item) {
          return Quote(
            text: item['q'],
            author: item['a'],
          );
        }).toList();

        setState(() {
          _quotes = quotes;
        });
      } else {
        throw Exception("Failed to load quotes");
      }
    } catch (e) {
      // Handle connection or parsing errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load quotes on app start
  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  // UI for each quote card
  Widget buildQuoteCard(Quote quote) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(
          '"${quote.text}"',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        subtitle: Text("- ${quote.author}"),
        trailing: IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share('"${quote.text}" — ${quote.author}');
          },
        ),
      ),
    );
  }

  // Main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Motivational Quotes"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchQuotes,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _quotes.length,
          itemBuilder: (context, index) {
            return buildQuoteCard(_quotes[index]);
          },
        ),
      ),
    );
  }
}
