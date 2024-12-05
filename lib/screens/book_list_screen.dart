import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:book_browse/widgets/image_with_placeholder.dart';
import 'package:book_browse/widgets/wave_dots.dart';
import 'package:book_browse/models/book.dart';
import 'package:book_browse/screens/book_detail_screen.dart';
import 'package:book_browse/services/api_service.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isRequesting = false;
  bool _hasMore = true;
  late ScrollController _scrollController;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _isSearching = false; // Add this to toggle search bar visibility

  final _cacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
            !_isLoading &&
            _hasMore) {
          _fetchBooks();
        }
      });
  }

  Future<void> _fetchBooks() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isRequesting = true;
      _errorMessage = '';
    });

    try {
      final cachedData = await _cacheManager.getFileFromCache('books_page_$_currentPage');

      if (cachedData != null) {
        final bytes = await cachedData.file.readAsBytes();
        final jsonData = utf8.decode(bytes);
        final List<dynamic> results = jsonDecode(jsonData);

        setState(() {
          _books.addAll(results.map((json) => Book.fromJson(json)).toList());
          _filteredBooks = List.from(_books); // Initialize filteredBooks
          _currentPage++;
        });
      } else {
        final results = await ApiService.fetchBooks(_currentPage);

        if (results.isNotEmpty) {
          _cacheManager.putFile(
            'books_page_$_currentPage',
            utf8.encode(jsonEncode(results)),
            fileExtension: 'json',
          );

          setState(() {
            _books.addAll(results.map((json) => Book.fromJson(json)).toList());
            _filteredBooks = List.from(_books); // Initialize filteredBooks
            _currentPage++;
          });
        } else {
          setState(() {
            _hasMore = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load books. Please try again later.";
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isRequesting = false;
      });
    }
  }

  void _searchBooks(String query) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _searchQuery = query;
        if (_searchQuery.isEmpty) {
          _filteredBooks = List.from(_books); // Show all books if search query is empty
        } else {
          _filteredBooks = _books.where((book) {
            final lowerCaseQuery = _searchQuery.toLowerCase();
            bool matchesTitle = book.title.toLowerCase().startsWith(lowerCaseQuery);
            bool matchesAuthor = book.authors.any((author) => author.toLowerCase().startsWith(lowerCaseQuery));
            bool matchesBookshelf = book.bookshelves.any((shelf) => shelf.toLowerCase().contains(lowerCaseQuery));

            bool isRelevanceMatch = book.authors.any((author) =>
                author.toLowerCase().contains(lowerCaseQuery));

            return matchesTitle || matchesAuthor || matchesBookshelf || isRelevanceMatch;
          }).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Discovery", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Toggle search bar visibility
                _searchQuery = ''; // Reset search query when opening search
              });
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search books...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: _searchBooks,
                  ),
                ),
              )
            : null, // Only show search bar if _isSearching is true
      ),
      body: _isRequesting && _filteredBooks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WaveDotsWidget(
                    color: Colors.blueAccent,
                    dotSize: 18.0,
                    dotCount: 5,
                    duration: Duration(milliseconds: 800),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Loading books, please wait...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchBooks,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.6,
                  ),
                  controller: _scrollController,
                  itemCount: _filteredBooks.length + (_hasMore ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == _filteredBooks.length) {
                      return _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: WaveDotsWidget()),
                            )
                          : const SizedBox.shrink();
                    }

                    final book = _filteredBooks[index];
                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailScreen(book: book),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ImageWithPlaceholder(
                                imageUrl: book.imageUrl,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    book.authors.isNotEmpty ? book.authors.join(', ') : "Unknown Author",
                                    style: const TextStyle(color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
