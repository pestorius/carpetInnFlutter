import 'package:carpetinn_flutter/carpetImageScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carpetinn_flutter/main.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class CarpetDetailScreen extends StatefulWidget {
  CarpetDetailScreen({Key key, this.carpet}) : super(key: key);
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
            isFavorited
                ? IconButton(
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
                  )
                : IconButton(
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
                  child: InkWell(
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
                  color: Colors.amberAccent,
                  onPressed: () {
                    Share.share(carpetUrl);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Share',
                      style: TextStyle(
                          fontSize: 19.0,
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
                  color: Colors.amberAccent,
                  onPressed: () {
                    enquireDialog(code);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Enquire',
                      style: TextStyle(
                          fontSize: 19.0,
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

  Future<void> enquireDialog(String code) async {
    var enquiryFontSize = 16.0;
    var iconSize = 50.0;
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                    child: Text(
                      'Enquire through',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.grey[600],
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            Email email = Email(
                                recipients: ['gauharaslam@yahoo.com'],
                                subject: 'Carpet-Inn: Enquiry - Code: $code');
                            FlutterEmailSender.send(email);
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.mail,
                                  size: iconSize,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: enquiryFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            _launchCaller('tel:+60123372788');
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.phone,
                                  size: iconSize,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: enquiryFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            //_launchMessage('sms:+60123372788');
                            _sendSMS('Code: $code', ['+60123372788']);
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  CupertinoIcons.conversation_bubble,
                                  size: iconSize,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: enquiryFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            FlutterOpenWhatsapp.sendSingleMessage(
                                '+60123372788', 'Code: $code');
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 2.0),
                                  child: Image.asset(
                                    'assets/whatsapp.png',
                                    width: iconSize - 12,
                                  ),
                                ),
                                Text(
                                  'Whatsapp',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.normal,
                                      fontSize: enquiryFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  _launchCaller(String number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  _launchMessage(String number) async {
    if (await canLaunch(number)) {
      await launch(number);
    } else {
      throw 'Could not launch $number';
    }
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
