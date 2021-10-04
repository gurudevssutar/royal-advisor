import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:royal_advisor/screens/fullscreenImage.dart';

class ClickableCachedImageWithAnimationToFullScreen extends StatelessWidget {
  final String animationTag;
  final String imageUrl;

  ClickableCachedImageWithAnimationToFullScreen(
      {required this.animationTag, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
          tag: animationTag,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
                child: Container(
                    width: 32, height: 32, child: CircularProgressIndicator())),
            errorWidget: (context, url, error) {
              print('Error: ${error}');
              print('URL: ${url}');
              return Icon(Icons.error);
            },
          )),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailScreen(tag: animationTag, url: imageUrl);
        }));
      },
    );
  }
}
