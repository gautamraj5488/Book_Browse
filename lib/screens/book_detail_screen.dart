import 'package:book_browse/utils/colors.dart';
import 'package:book_browse/widgets/image_with_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:book_browse/models/book.dart';
import 'package:url_launcher/url_launcher.dart';


class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  // Helper method to open URLs
  Future<void> _launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Could not open the link. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Move the theme initialization here

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.imageUrl != null)
              Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: ImageWithPlaceholder(imageUrl: book.imageUrl!, width: screenWidth, height: screenHeight * 0.7),
                ),
              ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(theme, Icons.book, "Title", book.title),
                    const Divider(),
                    _buildDetailRow(theme, Icons.numbers, "ID", book.id.toString()),
                    const Divider(),
                    _buildDetailRow(theme, Icons.person, "Authors", book.authors.join(', ')),
                    if (book.translators.isNotEmpty) ...[
                      const Divider(),
                      _buildDetailRow(theme, Icons.translate, "Translators", book.translators.join(', ')),
                    ],
                    const Divider(),
                    _buildDetailRow(theme, Icons.category, "Subjects", book.subjects.join(', ')),
                    const Divider(),
                    _buildDetailRow(theme, Icons.collections_bookmark, "Bookshelves", book.bookshelves.join(', ')),
                    const Divider(),
                    _buildDetailRow(theme, Icons.language, "Languages", book.languages.join(', ')),
                    const Divider(),
                    _buildDetailRow(theme, Icons.copyright, "Copyright", book.copyright ? "Yes" : "No"),
                    const Divider(),
                    _buildDetailRow(theme, Icons.download, "Download Count", book.downloadCount.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Formats",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
            ),
            const SizedBox(height: 10),
            ...book.formats.entries.map((entry) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.link, color: Colors.blueAccent),
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(entry.value, style: const TextStyle(fontSize: 12)),
                  onTap: () => _launchUrl(context, entry.value),
                  trailing: const Icon(Icons.open_in_browser, color: Colors.blueAccent),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Pass the theme parameter
  Widget _buildDetailRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 14, color: AppColors.textColor)),
            ],
          ),
        ),
      ],
    );
  }
}
