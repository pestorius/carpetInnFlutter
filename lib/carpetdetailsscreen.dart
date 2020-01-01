import 'package:carpetinn_flutter/carpetImageScreen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carpetinn_flutter/splashscreen.dart';
import 'dart:convert';

class CarpetDetailScreen extends StatefulWidget {
  CarpetDetailScreen({Key key, this.carpet})
      : super(key: key);
  final dynamic carpet;

  @override
  CarpetDetailScreenState createState() =>
      CarpetDetailScreenState(carpet: carpet);
}

class CarpetDetailScreenState extends State<CarpetDetailScreen> {
  CarpetDetailScreenState({Key key, this.carpet});
  final dynamic carpet;
  var isFavorited = false;
  var favoritesMap;
  FavoritesStorage storage = FavoritesStorage();

  @override
  void initState() {
    super.initState();
    storage.readFavorites().then((String value) {
      favoritesMap = json.decode(value);
      print(favoritesMap);
      setState(() {
        if (favoritesMap.containsKey(carpet['id'])) {
          isFavorited = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //storage
    FavoritesStorage storage = FavoritesStorage();

    //carpet variables
    var age = carpet['age'];
    var carpetUrl = carpet['carpetUrl'];
    var category = carpet['category'];
    var code = carpet['code'];
    var color = carpet['colour'];
    var design = carpet['design'];
    var dyes = carpet['dyes'];
    var id = carpet['id'];
    var imageUrl = carpet['imageUrl'];
    var knotCount = carpet['knotCount'];
    var material = carpet['material'];
    var origin = carpet['origin'];
    var size = carpet['size'];
    var carpetImage = NetworkImage(carpet['imageUrl']);

    //style variables
    var pageFont = 'OpenSans';

    //widget functions
    Widget designTextWidget(String detail) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(detail,
            style: TextStyle(fontSize: 20.0, fontFamily: 'OpenSans')),
      );
    }

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            isFavorited ?
            IconButton(
              tooltip: 'Unfavorite',
              icon: const Icon(
                Icons.star,
                color: Colors.amberAccent,
                size: 35.0,
              ),
              onPressed: () {
                setState(() {
                  isFavorited = false;
                });
                favoritesMap.remove(carpet['id']);
                storage.writeFavorites(json.encode(favoritesMap));
                print(favoritesMap);
              },
            ) :
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(
                Icons.star_border,
                color: Colors.amberAccent,
                size: 35.0,
              ),
              onPressed: () {
                setState(() {
                  isFavorited = true;
                });
                favoritesMap[carpet['id']] = carpet;
                storage.writeFavorites(json.encode(favoritesMap));
                print(favoritesMap);
              },
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            'Code: $code',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return CarpetImageScreen(image: carpetImage);
                      }));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ClipRect(
                        child: Hero(
                          tag: 'imageHero',
                          child: PhotoView(
                            backgroundDecoration:
                                BoxDecoration(color: Colors.white),
                            imageProvider: carpetImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            'Details',
                            style:
                                TextStyle(fontSize: 30.0, fontFamily: pageFont),
                          ),
                        ),
                        designTextWidget('Design: $design'),
                        designTextWidget('Size: $size cm'),
                        designTextWidget('Code: $code'),
                        designTextWidget('Origin: $origin'),
                        designTextWidget('Material: $material'),
                        designTextWidget('Knot Count: $knotCount'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0),
              child: ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                  color: Colors.grey[350],
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Share',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: pageFont),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, right: 10.0, top: 10.0),
              child: ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                  color: Colors.grey[350],
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enquire',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: pageFont),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
