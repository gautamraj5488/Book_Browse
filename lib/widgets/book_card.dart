import 'package:book_browse/models/book.dart';
import 'package:book_browse/utils/colors.dart';
import 'package:book_browse/utils/text_styles.dart';
import 'package:book_browse/widgets/image_with_placeholder.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final String searchQuery;

  const BookCard({
    required this.book,
    required this.onTap,
    required this.searchQuery,
  });

  double dynamicHeight(BuildContext context, double factor) {
  return MediaQuery.of(context).size.width * factor;
  }

  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor, 
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.2),
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageWithPlaceholder(
                  imageUrl: book.imageUrl,
                  width: double.infinity,
                  height: screenWidth > 1200 ? dynamicHeight(context,0.2) : screenWidth > 800 ? dynamicHeight(context,0.25) : dynamicHeight(context,0.25),
                  fit: BoxFit.scaleDown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedText(book.title, searchQuery, context, 12),
                    const SizedBox(height: 8),
                    _buildHighlightedText(
                        book.authors.join(", "), searchQuery, context, 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, BuildContext context, double fontSize) {
    if (query.isEmpty) {
      return Text(
        text,
        style: AppTextStyles(context).headingStyle.copyWith(fontSize: fontSize),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
    }

    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = query.toLowerCase();
    final queryIndex = lowerCaseText.indexOf(lowerCaseQuery);

    if (queryIndex == -1) {
      return Text(
        text,
        style: AppTextStyles(context).headingStyle.copyWith(fontSize: fontSize),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );
    }

    final beforeMatch = text.substring(0, queryIndex);
    final match = text.substring(queryIndex, queryIndex + query.length);
    final afterMatch = text.substring(queryIndex + query.length);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeMatch,
            style: AppTextStyles(context).headingStyle.copyWith(fontSize: fontSize),
          ),
          TextSpan(
            text: match,
            style: AppTextStyles(context).headingStyle.copyWith(
              fontSize: fontSize,
              color: AppColors.highlightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: afterMatch,
            style: AppTextStyles(context).headingStyle.copyWith(fontSize: fontSize),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
