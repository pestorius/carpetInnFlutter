import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CarpetImageScreen extends StatelessWidget {
  CarpetImageScreen({Key key, this.image}) : super(key: key);
  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        child: Hero(
          tag: 'imageHero',
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: image,
          ),
        ),
      ),
    );
  }
}
