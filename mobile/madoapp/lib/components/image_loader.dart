import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madoapp/configs/theme_config.dart';

class ImageLoader extends StatelessWidget {
  final double? imgSize;
  final String url;
  final double borderRadius;

  const ImageLoader({
    Key? key,
    required this.url,
    this.borderRadius = 8.0,
    this.imgSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          width: imgSize,
          height: imgSize,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
          width: imgSize ?? double.infinity,
          height: imgSize ?? 200,
          color: ThemeConfig.kLoadingGrey,
        ),
        errorWidget: (context, url, error) => Container(
          width: imgSize ?? double.infinity,
          height: imgSize ?? 200,
          color: ThemeConfig.kLoadingGrey,
        ),
      ),
    );
  }
}
