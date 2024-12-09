import 'dart:convert';
import 'package:book_browse/utils/app_theme.dart';
import 'package:book_browse/utils/text_styles.dart';
import 'package:book_browse/widgets/book_card.dart';
import 'package:book_browse/widgets/error_message.dart';
import 'package:book_browse/widgets/loading_indicator.dart';
import 'package:book_browse/widgets/shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:book_browse/models/book.dart';
import 'package:book_browse/screens/book_detail_screen.dart';
import 'package:book_browse/services/api_service.dart';
import 'package:book_browse/utils/colors.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isRequesting = false;
  bool _hasMore = true;
  late ScrollController _scrollController;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _isSearching = false;

  final _cacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMore && !_isSearching) {
          _fetchBooks();
        }
      });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

   void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _controller.forward();  // Start animation
      } else {
        _controller.reverse();  // Reverse animation
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
        _processResults(results);
      } else {
        final cachedData =
            await _cacheManager.getFileFromCache('books_page_$_currentPage');

        if (cachedData != null) {
          final bytes = await cachedData.file.readAsBytes();
          final jsonData = utf8.decode(bytes);
          final List<dynamic> results = jsonDecode(jsonData);
          _processResults(results);
        } else {
          // Fetch from API if no cache exists
          final results = await ApiService.fetchBooks(_currentPage);

          if (results.isNotEmpty) {
            // Cache the fetched data
            await _cacheManager.putFile(
              'books_page_$_currentPage',
              utf8.encode(jsonEncode(results)),
              fileExtension: 'json',
            );
            _processResults(results);
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

  void _processResults(List<dynamic> results) {
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
  }

void _searchBooks(String query) {
  setState(() {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredBooks = List.from(_books);
    } else {
      final lowerCaseQuery = _searchQuery.toLowerCase();

      _filteredBooks = _books.where((book) {
        return _anyWordStartsWith(book.title, lowerCaseQuery) ||
            book.authors.any((author) => _anyWordStartsWith(author, lowerCaseQuery)) ||
            book.bookshelves.any((shelf) => _anyWordStartsWith(shelf, lowerCaseQuery));
      }).toList();
    }
  });
}

bool _anyWordStartsWith(String text, String query) {
  return text.toLowerCase().split(' ').any((word) => word.startsWith(query));
}




  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.cardColor,
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _isSearching ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            "Book Browse",
            style: AppTextStyles(context).appBarTextStyle,
          ),
        ),
         actions: [
          Row(
            children: [
              if (_isSearching)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      decoration: AppTheme.containerDecoration,
                      width: MediaQuery.of(context).size.width * _widthAnimation.value,
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search books...",
                          hintStyle: AppTextStyles(context).searchBarTextStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.cardColor,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _searchBooks(value);
                        },
                      ),
                    );
                  },
                ),
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: AppColors.whiteColor,
                  size: screenWidth > 600 ? 30 : 24,
                ),
                onPressed: (){
                  _toggleSearch();
                  if (!_isSearching) {
                      _searchQuery = ''; 
                      _fetchBooks();
                    } 
                }
                 
              ),
            ],
          ),
        ],
      ),
      body: _isRequesting && _filteredBooks.isEmpty
          ? ShimmerWidget(screenWidth: screenWidth, itemCount: 20)
          : _errorMessage.isNotEmpty
              ? ErrorMessage(message: _errorMessage, onRetry: _fetchBooks)
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 1200 ? 4 : screenWidth > 800 ? 3 : 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: screenWidth > 1200 ? 0.4 : screenWidth > 800 ? 0.5 : 0.7,
                  ),
                  controller: _scrollController,
                  itemCount: _filteredBooks.length + (_hasMore ? 1 : 0),
                  itemBuilder: (ctx, index) {
                    if (index == _filteredBooks.length) {
                      return _isLoading ? const LoadingIndicator() : const SizedBox.shrink();
                    }
                    final book = _filteredBooks[index];
                    return BookCard(
                      book: book,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
                        );
                      }, searchQuery: _searchQuery,
                    );
                  },
                ),
    );
  }

}
