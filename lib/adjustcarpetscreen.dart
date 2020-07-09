import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

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
  Adjustcarpetscreen({Key key, this.carpetImage, this.backgroundImage})
      : super(key: key);
  final dynamic carpetImage;
  final dynamic backgroundImage;

  @override
  AdjustcarpetscreenState createState() => AdjustcarpetscreenState(
      carpetImage: carpetImage, backgroundImage: backgroundImage);
}

class AdjustcarpetscreenState extends State<Adjustcarpetscreen> {
  AdjustcarpetscreenState({Key key, this.carpetImage, this.backgroundImage});
  final dynamic carpetImage;
  final dynamic backgroundImage;
  img.Image photo;
  var image;
  var file;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (image == null) loadImageBundleBytes();
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          color: Colors.black,
          child: Image.file(backgroundImage)),
      Align(
          alignment: Alignment.center,
          child: image == null && file == null
              ? CircularProgressIndicator()
              : Image.file(file)),
    ]));
  }

  Future loadImageBundleBytes() async {
    ByteData imageBytes = await NetworkAssetBundle(Uri.parse(carpetImage.url))
        .load(carpetImage.url);
    file = await _localFile;

    setState(() {
      imageCache.clear();
      image = setImageBytes(imageBytes);
      file..writeAsBytesSync(img.encodePng(image));
      print('Created file');
    });
  }

  img.Image setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
    int pixel32 = photo.getPixelSafe(0, 0);
    int hex = abgrToArgb(pixel32);
    print(Color(hex));
    photo.setPixelRgba(27, 27, 0, 0, 0);
    photo.setPixelRgba(28, 28, 0, 0, 0);
    photo.setPixelRgba(29, 29, 0, 0, 0);
    photo.setPixelRgba(30, 30, 0, 0, 0);
    photo.setPixelRgba(31, 31, 0, 0, 0);
    photo.setPixelRgba(32, 32, 0, 0, 0);
    photo.setPixelRgba(33, 33, 0, 0, 0);
    print(photo.runtimeType);
    return photo;
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/carpet.png');
  }
}
