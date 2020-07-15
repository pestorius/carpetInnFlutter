import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as Img;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class Adjustcarpetscreen extends StatefulWidget {
  Adjustcarpetscreen({Key key, this.carpetTrimmedImage, this.backgroundImage})
      : super(key: key);
  final dynamic carpetTrimmedImage;
  final dynamic backgroundImage;

  @override
  AdjustcarpetscreenState createState() => AdjustcarpetscreenState(
      carpetTrimmedImage: carpetTrimmedImage, backgroundImage: backgroundImage);
}

class AdjustcarpetscreenState extends State<Adjustcarpetscreen> {
  AdjustcarpetscreenState(
      {Key key, this.carpetTrimmedImage, this.backgroundImage});
  final dynamic carpetTrimmedImage;
  final dynamic backgroundImage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(SizeConfig.screenWidth);
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          color: Colors.black,
          child: Image.file(backgroundImage)),
      Align(
          alignment: Alignment.center,
          child: Image(
            image: carpetTrimmedImage,
            width: SizeConfig.blockSizeHorizontal * 80,
          ))
    ]));
  }
}
