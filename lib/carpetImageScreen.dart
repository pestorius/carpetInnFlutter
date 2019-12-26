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
        decoration: new BoxDecoration(
          color: Colors.green,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: image,
          ),
        ),
      ),
    );
  }
}
