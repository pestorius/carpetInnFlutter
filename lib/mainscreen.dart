import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  MainScreen({Key key, this.title, this.handKnottedList, this.kilimList, this.machineMadeList})
      : super(key: key);
  final String title;
  final dynamic handKnottedList;
  final dynamic kilimList;
  final dynamic machineMadeList;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    //print(carpetsList[0]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // getRecord();
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.63),
            itemBuilder: (context, position) {
              return Center(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            height: 120.0,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            imageUrl: handKnottedList[position]['imageUrl'],
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(handKnottedList[position]['design'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15.0)),
                          ),
                          Text.rich(TextSpan(
                              text: handKnottedList[position]['size'],
                              style: TextStyle(fontSize: 15.0),
                              children: <TextSpan>[TextSpan(text: ' cm')])),
                        ],
                      )));
            },
            itemCount: handKnottedList.length,
          ),
        ),
      ),
    );
  }

  /*String getRecord(dynamic carpetHashMap, int position) {
    return carpetHashMap[position];
    */ /*databaseReference.once().then((DataSnapshot snapshot) {
      var carpets = [];
      var data = snapshot.value;
      data.forEach((k, v) => carpets.add(k));
      print(carpets[0]);
    });*/ /*
  }*/

  /*dynamic organizeData() {
    //var data;
    databaseReference.once().then((DataSnapshot snapshot) {
      // var carpets = [];
      var data = snapshot.value;
      print(data);
      return data;
      // data.forEach((k, v) => print(k));
    });
    //print('Data: $data');
    //return data;
  }*/
}
