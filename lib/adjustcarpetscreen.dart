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

/*class AdjustcarpetscreenState extends State<Adjustcarpetscreen> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
                print('INTIAL: $details');
                _startingFocalPoint = details.focalPoint;
              }),
              onScaleUpdate: (details) => setState(() {
                //print('UPDATE: $details');
                //print(_startingFocalPoint);
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
                //print('END: $details');
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
              }),
              child: Image(
                image: carpetTrimmedImage,
              ),
            ),
          )
        ],
      ),
    );
  }
}*/
/*class AdjustcarpetscreenState extends State<Adjustcarpetscreen> {
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
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              color: Colors.black,
              child: Image.file(backgroundImage)),
          MatrixGestureDetector(
              onMatrixUpdate: (m, tm, sm, rm) {
                notifier.value = m;

              },
              child: AnimatedBuilder(
                animation: notifier,
                builder: (ctx, child) {
                  return Transform(
                    transform: notifier.value
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * _offset.dy)
                      ..rotateY(-0.01 * _offset.dx),
                    origin: origin,
                    child: Container(
                      height: SizeConfig.screenHeight,
                      child: Image(
                        image: carpetTrimmedImage,
                      ),
                    ),
                  );
                },
              ),
            ),

          RotatedBox(
            quarterTurns: 1,
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              child: Slider.adaptive(
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
          )
        ],
      ),
    );
  }
}*/

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
                      print('INTIAL: $details');
                      _startingFocalPoint = details.focalPoint;
                    }),
                    onScaleUpdate: (details) => setState(() {
                      //print('UPDATE: $details');
                      //print(_startingFocalPoint);
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
                      //print('END: $details');
                      print('END: ($translatex, $translatey)');
                      endTranslatex = translatex;
                      endTranslatey = translatey;
                      endTranslatez = translatez;
                      endAngle = angle;
                      //origin = Offset(translatex, translatey);
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
                      //height: SizeConfig.blockSizeVertical * 90,
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
                    child: Slider.adaptive(
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
                )
              ],
            ),
          ],
        ),
      ),
    ]));
  }
}
