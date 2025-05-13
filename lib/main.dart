import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/quote_model.dart';
import 'services/quote_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivational Quotes',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: QuotesHomePage(),
    );
  }
}

class QuotesHomePage extends StatefulWidget {
  @override
  _QuotesHomePageState createState() => _QuotesHomePageState();
}

class _QuotesHomePageState extends State<QuotesHomePage> {
  List<Quote> _quotes = [];
  bool _isLoading = false;

  Future<void> fetchQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _quotes = await QuoteService.fetchQuotes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Motivational Quotes")),
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
