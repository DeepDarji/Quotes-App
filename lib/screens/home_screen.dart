// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/category_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteService _quoteService = QuoteService();
  List<Quote> _quotes = [];
  bool _isLoading = true;
  String _selectedCategory = 'inspirational';
  String _errorMessage = '';

  final List<String> _categories = [
    'inspirational',
    'life',
    'love',
    'funny',
    'wisdom',
    'success',
  ];

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';  // Clear any previous error messages
    });
    try {
      final quotes = await _quoteService.fetchQuotes(category: _selectedCategory);
      setState(() {
        _quotes = quotes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load quotes. Please check your internet connection or try again later.';
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _errorMessage = '';  // Clear previous errors
    });
    _loadQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivational Quotes'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadQuotes,
        child: Column(
          children: [
            CategoryFilter(
              categories: _categories,
              selected: _selectedCategory,
              onSelected: _onCategorySelected,
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()) // Show loader while fetching
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) // Show error message if failed
            else if (_quotes.isEmpty)
                const Center(child: Text('No quotes available at the moment.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                      return QuoteCard(quote: _quotes[index]);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
