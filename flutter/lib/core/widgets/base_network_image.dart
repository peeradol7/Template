import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BaseNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const BaseNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
      ),
    );
  }
}
