import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            // Stroked text as border.
            Text(
              'Carpet Inn',
              style: TextStyle(
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.black,
                letterSpacing: letterspacing,
                fontFamily: 'Gelasio-Regular'
              ),
            ),
            // Solid text as fill.
            Text(
              'Carpet Inn',
              style: TextStyle(
                fontSize: 40,
                color: Colors.amber,
                letterSpacing: letterspacing,
                fontFamily: 'Gelasio-Regular'
              ),
            ),
          ],
        )
        //child: Text('Carpet Inn', style: TextStyle(fontSize: 40.0,
                                                   //color: Colors.amberAccent),),
      ),
    );

  }
}


