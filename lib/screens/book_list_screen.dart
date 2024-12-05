import 'package:book_browse/widgets/wave_dots.dart';
import 'package:flutter/material.dart';
import 'package:book_browse/models/book.dart';
import 'package:book_browse/screens/book_detail_screen.dart';
import 'package:book_browse/services/api_service.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isRequesting = false; // Track if the request is in progress
  bool _hasMore = true; // Track if there are more books to load
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fetchBooks();

    // Scroll Controller to detect when the user reaches the bottom of the list
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if (!_isLoading && _hasMore) {
            _fetchBooks(); // Load more books when scrolled to the bottom
          }
        }
      });
  }

  // Fetch books from the API
  Future<void> _fetchBooks() async {
    if (_isLoading) return; // Prevent multiple API calls
    setState(() {
      _isLoading = true;
      _isRequesting = true; // Show the request message when the API is called
    });

    try {
      final results = await ApiService.fetchBooks(_currentPage);

      if (results.isNotEmpty) {
        setState(() {
          _books.addAll(results.map((json) => Book.fromJson(json)).toList());
          _currentPage++; // Increment page number for the next request
        });
      } else {
        setState(() {
          _hasMore = false; // No more books to load
        });
      }
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _isRequesting = false; // Hide the request message after the response
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose ScrollController when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Discovery"),
      ),
      body: _isRequesting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WaveDotsWidget(
                    color: Colors.blue,
                    dotSize: 15.0,
                    dotCount: 5,
                    duration: Duration(milliseconds: 800),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Please wait, loading books...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _books.length + (_hasMore ? 1 : 0), // Add extra item for the loading indicator only if there are more books
              itemBuilder: (ctx, index) {
                if (index == _books.length) {
                  // Show loading indicator at the bottom
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink(); // Hide loading indicator when no more books
                }
                final book = _books[index];
                return ListTile(
                  leading: book.imageUrl != null
                      ? Image.network(
                          book.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () {
                    // Navigate to book details screen when the user taps a book
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(book: book),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
