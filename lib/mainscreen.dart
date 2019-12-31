import 'package:carpetinn_flutter/aboutusscreen.dart';
import 'package:carpetinn_flutter/carpetdetailsscreen.dart';
import 'package:carpetinn_flutter/favoritesscreen.dart';
import 'package:carpetinn_flutter/homescreen.dart';
import 'package:carpetinn_flutter/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'homescreen.dart';

class Main extends StatefulWidget {
  Main(
      {Key key,
      this.title,
      this.handKnottedList,
      this.kilimList,
      this.machineMadeList});
  final String title;
  final dynamic handKnottedList;
  final dynamic kilimList;
  final dynamic machineMadeList;
  @override
  State<StatefulWidget> createState() {
    return MainState(
        title: title,
        handKnottedList: handKnottedList,
        kilimList: kilimList,
        machineMadeList: machineMadeList);
  }
}

class MainState extends State<Main> {
  MainState(
      {Key key,
      this.title,
      this.handKnottedList,
      this.kilimList,
      this.machineMadeList});
  final String title;
  final dynamic handKnottedList;
  final dynamic kilimList;
  final dynamic machineMadeList;
  final databaseReference = FirebaseDatabase.instance.reference();
  int currentIndex = 0;
  List<Widget> children = [];

  @override
  void initState() {
    super.initState();
    children = [
      HomeScreen(
          title: title,
          handKnottedList: handKnottedList,
          kilimList: kilimList,
          machineMadeList: machineMadeList),
      SearchScreen(
          handKnottedList: handKnottedList,
          kilimList: kilimList,
          machineMadeList: machineMadeList),
      FavoritesScreen(),
      AboutUsScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text(
                'Search',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
              ),
              title: Text('Favorites'),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.info,
                ),
                title: Text(
                  'About Us',
                ))
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
