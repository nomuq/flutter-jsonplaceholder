import 'package:flutter/material.dart';
import 'package:jsonplaceholder/models/Photo.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final Photo photo;

  const ImageViewer({Key key, this.photo}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.photo.title),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.photo.url),
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }
}
