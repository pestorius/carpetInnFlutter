import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Container(
          height: 55.0,
          width: double.infinity,
          margin: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
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
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
