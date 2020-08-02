import 'package:carpetinn_flutter/adjustcarpetscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:transparent_image/transparent_image.dart';

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

class Threedviewscreen extends StatefulWidget {
  Threedviewscreen({Key key, this.carpetTrimmedImage}) : super(key: key);
  final dynamic carpetTrimmedImage;

  @override
  _ThreedviewscreenState createState() =>
      _ThreedviewscreenState(carpetTrimmedImage: carpetTrimmedImage);
}

class _ThreedviewscreenState extends State<Threedviewscreen> {
  _ThreedviewscreenState({Key key, this.carpetTrimmedImage});
  final dynamic carpetTrimmedImage;
  final picker = ImagePicker();
  File _image;

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery == true ? ImageSource.gallery : ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
      if (_image != null)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Adjustcarpetscreen(
                    carpetTrimmedImage: carpetTrimmedImage,
                    backgroundImage: _image,
                  )),
        );
    });
  }

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 50),
                width: SizeConfig.blockSizeHorizontal * 80,
                child: Text(
                  'Welcome to the 3D Viewer! Use this tool to overlay the selected carpet onto a living space.',
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Carpet Selected:',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5.3,
                    fontFamily: 'OpenSans'),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 50),
                height: SizeConfig.screenHeight * 0.3,
                child: Stack(
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: carpetTrimmedImage.url,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.amberAccent,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 3,
                        right: SizeConfig.blockSizeHorizontal * 3,
                        top: 12,
                        bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      getImage(true);
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.amberAccent,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 3,
                        right: SizeConfig.blockSizeHorizontal * 3,
                        top: 12,
                        bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      getImage(false);
                    },
                    child: Text(
                      'Take A Photo',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.2,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
