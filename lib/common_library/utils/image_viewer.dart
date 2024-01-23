import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage(name: 'ImageViewer')
class ImageViewer extends StatelessWidget {
  final String? title;
  final NetworkImage? image;

  const ImageViewer({Key? key, this.title, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: PhotoView(
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: image,
      ),
    );
  }
}
