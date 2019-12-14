import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transparent_image/transparent_image.dart';
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
  MainScreen({Key key, this.title, @required this.carpetsHashMap})
      : super(key: key);
  final String title;
  final dynamic carpetsHashMap;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    var carpetsList = carpetsHashMap.values.toList();
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
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, position) {
              return Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: carpetsList[position]['imageUrl'],
                  ),
                ],
              );
            },
            itemCount: 5,
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
