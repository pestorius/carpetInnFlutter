import 'package:flutter/material.dart';
import 'package:carpetinn_flutter/carpetdetailsscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen(
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            title: Text(
              this.title,
              style: TextStyle(
                  color: Color.fromRGBO(43, 14, 230, 1),
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockSizeVertical * 3.3),
            ),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(
                0, SizeConfig.blockSizeVertical * 6
              ),
              child: TabBar(
                labelColor: Colors.black,
                labelStyle:
                    TextStyle(fontSize: SizeConfig.blockSizeVertical * 2, fontFamily: 'Lora', fontWeight: FontWeight.bold),
                tabs: <Widget>[
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text('Hand-knotted'),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text('Kilim'),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text('Machine Made'),
                    ),
                  ),
                ],
              ),
            ),
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
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.63),
        itemBuilder: (context, position) {
          return Center(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarpetDetailScreen(
                              carpet: carpetsList[position]
                            )),
                  );
                },
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
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(carpetsList[position]['design'],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15.0)),
                        ),
                        Text.rich(TextSpan(
                            text: carpetsList[position]['size'],
                            style: TextStyle(fontSize: 15.0),
                            children: <TextSpan>[TextSpan(text: ' cm')])),
                      ],
                    ))),
          );
        },
        itemCount: carpetsList.length,
      ),
    );
  }
}
