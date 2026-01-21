import 'package:flutter/material.dart';

class ImageViewerDialog extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ImageViewerDialog({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: .symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            },
            errorBuilder: (context, error, stack) =>
                const Center(child: Icon(Icons.error, color: Colors.white, size: 50)),
          ),
        ),
        ),
      ),
    );
  }
}
