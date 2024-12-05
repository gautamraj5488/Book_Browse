import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  int _currentPage = 1;
  bool _isLoading = false;

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final results = await ApiService.fetchBooks(_currentPage);
      _books.addAll(results.map((json) => Book.fromJson(json)).toList());
      _currentPage++;
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
