import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainScreen extends StatelessWidget {
  MainScreen(
      {Key key,
      this.title,
      this.handKnottedList,
      this.kilimList,
      this.machineMadeList})
      : super(key: key);
  final String title;
  final dynamic handKnottedList;
  final dynamic kilimList;
  final dynamic machineMadeList;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  text: 'Hand-Knotted',
                ),
                Tab(
                  text: "Kilim",
                ),
                Tab(
                  text: "Machine Made",
                )
              ],
            ),
            title: Text(
              this.title,
              style: TextStyle(
                color: Colors.black,
                //fontFamily: 'Lora',
                //fontSize: 24.0
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: <Widget>[
              tabBodies(handKnottedList),
              tabBodies(kilimList),
              tabBodies(machineMadeList)
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBodies(var carpetsList) {
    return Center(
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
                        imageUrl: carpetsList[position]['imageUrl'],
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(carpetsList[position]['design'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0)),
                      ),
                      Text.rich(TextSpan(
                          text: carpetsList[position]['size'],
                          style: TextStyle(fontSize: 15.0),
                          children: <TextSpan>[TextSpan(text: ' cm')])),
                    ],
                  )));
        },
        itemCount: carpetsList.length,
      ),
    );
  }
}
