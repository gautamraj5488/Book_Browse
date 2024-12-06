import 'package:book_browse/widgets/wave_dots.dart';
import 'package:flutter/material.dart';

class ImageWithPlaceholder extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageWithPlaceholder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Image.network(
            imageUrl!,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: Container(
                  height: height,
                  padding: EdgeInsets.all(6),
                  child: WaveDotsWidget(),
                )
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'assets/images/error.jpg',
                width: width*0.1,
                height: height*0.1,
                fit: fit,
              );
            },
          )
        : Image.asset(
            'assets/images/images.png',
            width: width,
            height: height,
            fit: fit,
          );
  }
}
