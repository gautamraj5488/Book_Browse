import 'dart:convert';
import 'package:book_browse/widgets/shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:book_browse/widgets/image_with_placeholder.dart';
import 'package:book_browse/widgets/wave_dots.dart';
import 'package:book_browse/models/book.dart';
import 'package:book_browse/screens/book_detail_screen.dart';
import 'package:book_browse/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

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

      if (kIsWeb) {
        final results = await ApiService.fetchBooks(_currentPage);

        if (results.isNotEmpty) {
          setState(() {
            _books.addAll(results.map((json) => Book.fromJson(json)).toList());
            _filteredBooks = List.from(_books);
            _currentPage++;
          });
        } else {
          setState(() {
            _hasMore = false;
          });
        }
      } else {
        final cachedData = await _cacheManager.getFileFromCache('books_page_$_currentPage');

        if (cachedData != null) {
          final bytes = await cachedData.file.readAsBytes();
          final jsonData = utf8.decode(bytes);
          final List<dynamic> results = jsonDecode(jsonData);

          setState(() {
            _books.addAll(results.map((json) => Book.fromJson(json)).toList());
            _filteredBooks = List.from(_books);
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
              _filteredBooks = List.from(_books);
              _currentPage++;
            });
          } else {
            setState(() {
              _hasMore = false;
            });
          }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double childAspectRatio;
    if (screenWidth > 1200) {
      childAspectRatio = 0.4; // Decreased for larger screens
    } else if (screenWidth > 800) {
      childAspectRatio = 0.5; // Decreased for medium screens
    } else {
      childAspectRatio = 0.7; // Decreased for smaller screens
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Discovery",
          style: TextStyle(
            fontSize: screenWidth > 600 ? 24 : 18, // Scalable font size
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: screenWidth > 600 ? 30 : 24, // Larger icons for tablets/desktops
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: Size.fromHeight(56),
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
            : null,
      ),

      body: _isRequesting && _filteredBooks.isEmpty
          ?  ShimmerWidget(screenWidth: screenWidth, itemCount: 20,)
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 1200
                      ? 4 // Layout for desktops
                      : screenWidth > 800
                          ? 3 // Layout for tablets
                          : 2, // Layout for phones
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: childAspectRatio
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
                        child: SingleChildScrollView(
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth > 600 ? 18 : 16,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      book.authors.isNotEmpty ? book.authors.join(', ') : "Unknown Author",
                                      style: TextStyle(
                                        fontSize: screenWidth > 600 ? 14 : 12, // Adjust for screen width
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    );
                  },
                ),
    );
  }
}



