import 'package:flutter/material.dart';
import 'package:carpetinn_flutter/main.dart';
import 'dart:convert';
import 'package:carpetinn_flutter/carpetdetailsscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    print(screenWidth);
    print(screenHeight);
  }
}

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({Key key}) : super(key: key);

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesScreenState({Key key});
  //storage
  FavoritesStorage storage = FavoritesStorage();
  var favoritesMap;
  var favoritesList = [];
  var anyFavorites = false;

  @override
  void initState() {
    super.initState();
    storage.readFavorites().then((String value) {
      favoritesMap = json.decode(value);
      favoritesList = favoritesMap.values.toList();
      print(favoritesList.length);
      setState(() {
        if (favoritesList.length > 0) {
          anyFavorites = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double ratio = 0.0;
    if ((SizeConfig.screenWidth/SizeConfig.screenHeight) > 0.7) {
      ratio = 0.8;
    } else {
      ratio = 0.7;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
              color: Colors.black, fontSize: 22.0, fontFamily: 'OpenSans'),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: !anyFavorites
          ? Center(
              child: Text('No favorites'),
            )
          : GridView.builder(
              padding: EdgeInsets.only(top: 25.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: ratio),
              itemBuilder: (context, position) {
                return Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarpetDetailScreen(
                                    carpet: favoritesList[position]
                                  )),
                        );
                      },
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              CachedNetworkImage(
                                height: SizeConfig.blockSizeHorizontal * 25,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                imageUrl: favoritesList[position]['imageUrl'],
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 5),
                                child: Text(favoritesList[position]['design'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5)),
                              ),
                              Text.rich(TextSpan(
                                  text: favoritesList[position]['size'],
                                  style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                                  children: <TextSpan>[TextSpan(text: ' cm')])),
                            ],
                          ))),
                );
              },
              itemCount: favoritesList.length,
            ),
    );
  }
}
