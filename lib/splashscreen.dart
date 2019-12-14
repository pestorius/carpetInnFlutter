import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'mainscreen.dart';

void main() {
  runApp(MaterialApp(
    home: CarpetInnApp(),
  ));
}

class CarpetInnApp extends StatefulWidget {
  @override
  CarpetInnAppState createState() => new CarpetInnAppState();
}

class CarpetInnAppState extends State<CarpetInnApp> {
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
    /*Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(
                  title: "Carpet Inn",
                ))));*/
    /*Future<void> prepareToNavigate() async => {

      await organizeData();
    };*/
  }

  Future<void> fetchDataFromFirebase() async{
    var hashMap = await organizeData();
    //print(hashMap);
    //print(await organizeData());
    return Future.delayed(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => MainScreen(
          title: "Carpet Inn",
          carpetsHashMap: hashMap,
        ))));
  }

  dynamic organizeData() {
    //var data;
    var databaseReference = FirebaseDatabase.instance.reference();
    return databaseReference.once().then((DataSnapshot snapshot) {
      // var carpets = [];
      var data = snapshot.value;
      return data;
      // data.forEach((k, v) => print(k));
    });
    //print('Data: $data');
    //return data;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpet Inn',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  SplashScreen({Key key}) : super(key: key);
  final letterspacing = 3.0;
  final logofont = 'Lora';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/splash_screen_rug.jpg",
              width: size.width,
              height: size.height,
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Text(
              'Carpet Inn',
              style: TextStyle(
                  fontSize: 50,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4.3
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
                  fontSize: 50,
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
                  fontSize: 17.0,
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
                fontSize: 17.0,
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
