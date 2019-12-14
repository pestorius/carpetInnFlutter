import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

/*void main() {
  runApp(MainScreen());
}*/

/*class MainScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Demo Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home page'),
    );
  }
}*/
class MainScreen extends StatelessWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            getRecord();
          },
          child: Text('Hello World'),
        ),
      ),
    );
  }

  void getRecord() {
    databaseReference.once().then((DataSnapshot snapshot) {
      var carpets = [];
      var data = snapshot.value;
      data.forEach((k,v) => carpets.add(k));
      print(carpets[0]);
    });

    /*void getRecord() {
      var db = databaseReference.child("carpet-inn");
      db.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key,values) {
          print(values);
        });
      });
    }*/
  }

  /*static Future<int> getUserAmount() async {
    final response = await FirebaseDatabase.instance
        .reference()
        .child("22")
        .once();
    var users = [];
    response.value.forEach((v) => users.add(v));
    print(users);
    return users.length;
  }*/
}


