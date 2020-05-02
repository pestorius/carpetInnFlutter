import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'mainscreen.dart';
import 'dart:convert';
import "dart:math";
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: CarpetInnApp(storage: FavoritesStorage()),
  ));
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init (BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    print(screenWidth);
    print(screenHeight);
  }
}

class CarpetInnApp extends StatefulWidget {
  final FavoritesStorage storage;

  CarpetInnApp({Key key, @required this.storage}) : super(key: key);

  @override
  CarpetInnAppState createState() => new CarpetInnAppState();
}

class CarpetInnAppState extends State<CarpetInnApp> {
  var backgroundPic;
  var favoritesHashMap = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
    pickBackground();
    widget.storage.readFavorites().then((String value) {
      if (value == '') {
        print('Favorites file has not been created');
        widget.storage.writeFavorites('{}');
      } else {
        favoritesHashMap = json.decode(value);
        print(favoritesHashMap);
      }
    });
  }

  Future<void> fetchDataFromFirebase() async {
    var carpetLists = await organizeData();
    return Future.delayed(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Main(
                  title: "Carpet Inn",
                  handKnottedList: carpetLists[0],
                  kilimList: carpetLists[1],
                  machineMadeList: carpetLists[2],
                ))));
  }

  dynamic organizeData() {
    var handKnottedList = [];
    var kilimList = [];
    var machineMadeList = [];

    var databaseReference = FirebaseDatabase.instance.reference();
    return databaseReference.once().then((DataSnapshot snapshot) {
      var list = snapshot.value.values.toList();
      for (var i = 0; i < list.length; i++) {
        if (list[i]['category'] == 'Hand-Knotted') {
          handKnottedList.add(list[i]);
        } else if (list[i]['category'] == 'Kilim') {
          kilimList.add(list[i]);
        } else if (list[i]['category'] == 'Machine Made') {
          machineMadeList.add(list[i]);
        }
      }
      print(handKnottedList.length);
      print(kilimList.length);
      print(machineMadeList.length);
      return [handKnottedList, kilimList, machineMadeList];
    });
  }

  Future pickBackground() async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.jpg'))
        .toList();

    setState(() {
      final _random = new Random();
      backgroundPic = imagePaths[_random.nextInt(imagePaths.length)];
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpet Inn',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: SplashScreen(
        backgroundPic: backgroundPic ?? 'assets/6983.jpg',
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  SplashScreen({Key key, this.backgroundPic}) : super(key: key);
  final letterspacing = 3.0;
  final logofont = 'Lora';
  final backgroundPic;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              backgroundPic,
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Text(
              'Carpet Inn',
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 13,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.black,
                  letterSpacing: letterspacing,
                  fontFamily: logofont),
            ),
            // Solid text as fill.
          ),
          Center(
            child: Text(
              'Carpet Inn',
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 13,
                  color: Colors.amber,
                  letterSpacing: letterspacing,
                  fontFamily: logofont),
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 0.0,
            right: 0.0,
            child: Text(
              'owned by Petal World Sdn. Bhd.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.3
                    ..color = Colors.black,
                  letterSpacing: 2.0,
                  fontFamily: logofont),
            ),
            // Solid text as fill.
          ),
          Positioned(
            bottom: 40.0,
            left: 0.0,
            right: 0.0,
            child: Text(
              'owned by Petal World Sdn. Bhd.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.amber,
                letterSpacing: 2.0,
                fontFamily: logofont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/favorites.txt');
  }

  Future<String> readFavorites() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  Future<File> writeFavorites(String favorites) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$favorites');
  }
}
