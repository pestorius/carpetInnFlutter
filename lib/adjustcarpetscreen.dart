import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

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

  Offset _offset = Offset.zero;
  double translatex = 0,
      translatey = 0,
      translatez = 1,
      endTranslatex = 0,
      endTranslatey = 0,
      endTranslatez = 1;
  Offset _startingFocalPoint = Offset.zero;
  Offset origin = Offset.zero;
  double angle = 0, endAngle = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('3D Viewer', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
      Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          color: Colors.black,
          child: Image.file(backgroundImage)),
      Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(0.01 * _offset.dy)
                    ..rotateY(-0.01 * _offset.dx)
                    ..translate(translatex, translatey)
                    ..scale(translatez)
                    ..rotateZ(angle),
                  alignment: FractionalOffset.center,
                  origin: origin,
                  child: GestureDetector(
                    onScaleStart: (details) => setState(() {
                      _startingFocalPoint = details.focalPoint;
                    }),
                    onScaleUpdate: (details) => setState(() {
                      translatex = details.focalPoint.dx -
                          _startingFocalPoint.dx +
                          endTranslatex;
                      translatey = details.focalPoint.dy -
                          _startingFocalPoint.dy +
                          endTranslatey;
                      translatez = details.scale * endTranslatez;
                      angle = details.rotation + endAngle;
                    }),
                    onScaleEnd: (details) => setState(() {
                      print('END: ($translatex, $translatey)');
                      endTranslatex = translatex;
                      endTranslatey = translatey;
                      endTranslatez = translatez;
                      endAngle = angle;
                    }),
                    onDoubleTap: () => setState(() {
                      translatex = 0;
                      translatey = 0;
                      translatez = 1;
                      angle = 0;
                      endTranslatex = 0;
                      endTranslatey = 0;
                      endTranslatez = 1;
                      endAngle = 0;
                      origin = Offset.zero;
                    }),
                    child: Container(
                      child: Image(
                        image: carpetTrimmedImage,
                        width: SizeConfig.blockSizeHorizontal * 80,
                      ),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 80,
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Color(0xFFD4AF37),
                        activeTrackColor: Color(0xFF050230),
                        inactiveTrackColor: Color(0xFF050230),
                        trackHeight: 4.0,
                        trackShape: RectangularSliderTrackShape(),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                        overlayColor: Colors.amberAccent.withAlpha(32),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 22.0),
                      ),
                      child: Slider(
                        value: _offset.dy,
                        onChanged: (newOffset) {
                          setState(() {
                            _offset = Offset(0, newOffset);
                          });
                        },
                        min: -150,
                        max: 0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]));
  }
}
