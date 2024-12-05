import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://gutendex.com/books/";

  // Fetch books from the API based on the current page
  static Future<List<Map<String, dynamic>>> fetchBooks(int page) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Failed to load books');
    }
  }
}
