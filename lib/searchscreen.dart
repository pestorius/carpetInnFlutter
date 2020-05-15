import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
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
  }
}

class SearchScreen extends StatelessWidget {
  SearchScreen(
      {Key key, this.handKnottedList, this.kilimList, this.machineMadeList})
      : super(key: key);
  final dynamic handKnottedList;
  final dynamic kilimList;
  final dynamic machineMadeList;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var combinedList =
        [handKnottedList, kilimList, machineMadeList].expand((x) => x).toList();
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.search,
            color: Colors.grey,
            size: 120.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 170.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Search for carpet designs, eg. \"Tabriz\"\nor\n carpets codes, eg. 2315',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17.0, fontFamily: 'OpenSans'),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showSearch(
                context: context,
                delegate: CarpetSearch(combinedList: combinedList));
          },
          child: Container(
            height: 50.0,
            width: double.infinity,
            margin: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.search,
                    size: 30.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Search for a design or code',
                    style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5, color: Colors.grey[600]),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class CarpetSearch extends SearchDelegate {
  CarpetSearch({Key key, this.combinedList});
  final dynamic combinedList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SizeConfig().init(context);
    var searchedList = [];
    combinedList.forEach((element) {
      if (!isNumeric(query)) {
        if (equals(element['design'].toLowerCase(), query.toLowerCase())) {
          searchedList.add(element);
        } else
          print(element['design']);
      } else if (isNumeric(query)) {
        if (equals(element['code'], query)) {
          searchedList.add(element);
        }
      }
    });

    if (searchedList.length == 0) {
      query = '';
      return Center(
          child: Text(
        'No results',
        style: TextStyle(fontSize: 20.0),
      ));
    } else {
      double ratio = 0.0;
      if ((SizeConfig.screenWidth / SizeConfig.screenHeight) > 0.7) {
        ratio = 0.8;
      } else {
        ratio = 0.7;
      }
      return GridView.builder(
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
                              carpet: searchedList[position],
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
                          imageUrl: searchedList[position]['imageUrl'],
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(searchedList[position]['design'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 3.5)),
                        ),
                        Text.rich(TextSpan(
                            text: searchedList[position]['size'],
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                            children: <TextSpan>[TextSpan(text: ' cm')])),
                      ],
                    ))),
          );
        },
        itemCount: searchedList.length,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionsList = [];
    var imageList = [];

    // design queried
    if (isAlpha(query.replaceAll(" ", ""))) {
      combinedList.forEach((element) {
        if (contains(element['design'].toLowerCase(), query.toLowerCase())) {
          if (!suggestionsList.contains(element['design']))
            suggestionsList.add(element['design']);
        }
      });
      suggestionsList.sort();
      // code queried
    } else if (isNumeric(query)) {
      combinedList.forEach((element) {
        if (contains(element['code'], query)) {
          suggestionsList.add(element['code']);
          imageList.add(element['imageUrl']);
        }
      });
      // map suggestionsList with imageList
      final Map<dynamic, dynamic> mappings = {
        for (int i = 0; i < suggestionsList.length; i++)
          suggestionsList[i]: imageList[i]
      };
      suggestionsList.sort();
      var sequenceMatchCount = 0;
      // show results that match index-wise first
      for (var i = 0; i < suggestionsList.length; i++) {
        if (suggestionsList[i][0] == query[0]) {
          sequenceMatchCount++;
          for (var j = 0; j < query.length; j++) {
            if (suggestionsList[i][j] == query[j]) {
              var code = suggestionsList[i];
              suggestionsList.removeAt(i);
              suggestionsList.insert(0, code);
            } else {
              continue;
            }
          }
        }
      }
      // Sorts [list] between [start] (inclusive) and [end] (exclusive).
      if (sequenceMatchCount > 0)
        suggestionsList.setRange(0, sequenceMatchCount, suggestionsList.sublist(0, sequenceMatchCount)..sort());
      imageList = [
        for (var suggestion in suggestionsList) mappings[suggestion]
      ];
    }

    // return two different types of lists depending on search type
    if (isNumeric(query)) {
      return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                showResults(context);
                query = suggestionsList[index];
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      suggestionsList[index],
                      style: TextStyle(fontSize: 18.0, fontFamily: 'OpenSans'),
                    ),
                    CachedNetworkImage(
                      width: SizeConfig.blockSizeHorizontal * 10,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                      imageUrl: imageList[index],
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: suggestionsList.length);
    } else {
      return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                showResults(context);
                query = suggestionsList[index];
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 50,
                child: Text(
                  suggestionsList[index],
                  style: TextStyle(fontSize: 18.0, fontFamily: 'OpenSans'),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: suggestionsList.length);
    }
  }
}
