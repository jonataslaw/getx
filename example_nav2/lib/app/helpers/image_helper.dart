import 'package:flutter/material.dart';

Image returnImageWithErrorHandling(String imageUrl, {double? height}) {
  return Image.network(imageUrl, height: height,
    loadingBuilder: (BuildContext context, Widget child,
        ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder: (BuildContext context, Object exception,
        StackTrace? stackTrace) {
      return const Text('😢');
    },);
}