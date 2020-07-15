import 'package:carpetinn_flutter/carpetImageScreen.dart';
import 'package:carpetinn_flutter/threedviewscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:carpetinn_flutter/main.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      setState(() {
        if (favoritesMap.containsKey(carpet['id'])) {
          isFavorited = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
    var carpetTrimmedImage = NetworkImage(carpet['carpetPngUrl']);

    //style variables
    var pageFont = 'OpenSans';

    //widget functions
    Widget designTextWidget(String detail) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(detail,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                fontFamily: 'OpenSans')),
      );
    }

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
              tooltip: '3D View',
              icon: const Icon(
                Icons.aspect_ratio,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Threedviewscreen(carpetTrimmedImage: carpetTrimmedImage)),
                );
              },
            ),
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
                    },
                  ),
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
                    padding: const EdgeInsets.only(top: 4.0, left: 15.0),
                    child: Table(
                      columnWidths: {1: FractionColumnWidth(.73)},
                      children: [
                        TableRow(children: [
                          Text(
                            'Details',
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 6.5,
                                fontFamily: pageFont),
                          ),
                          Text('')
                        ]),
                        TableRow(children: [
                          designTextWidget('Design:'),
                          designTextWidget(design),
                        ]),
                        TableRow(children: [
                          designTextWidget('Size:'),
                          designTextWidget('$size cm'),
                        ]),
                        TableRow(children: [
                          designTextWidget('Code:'),
                          designTextWidget(code),
                        ]),
                        TableRow(children: [
                          designTextWidget('Origin:'),
                          designTextWidget(origin),
                        ]),
                        TableRow(children: [
                          designTextWidget('Material:'),
                          designTextWidget(material),
                        ]),
                        TableRow(children: [
                          designTextWidget('Knot Count:'),
                          designTextWidget(knotCount),
                        ]),
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
              padding: const EdgeInsets.only(
                  bottom: 5.0, top: 5.0, left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: SizeConfig.blockSizeHorizontal * 10,
                child: RaisedButton(
                  color: Colors.amberAccent,
                  onPressed: () {
                    Share.share(carpetUrl);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                        left: SizeConfig.blockSizeHorizontal * 2,
                        right: SizeConfig.blockSizeHorizontal * 2),
                    child: Text(
                      'Share',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.2,
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
              padding: const EdgeInsets.only(
                  bottom: 5.0, top: 5.0, left: 10.0, right: 10.0),
              child: ButtonTheme(
                height: SizeConfig.blockSizeHorizontal * 10,
                child: RaisedButton(
                  color: Colors.amberAccent,
                  onPressed: () {
                    enquireDialog(code);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                        left: SizeConfig.blockSizeHorizontal * 2,
                        right: SizeConfig.blockSizeHorizontal * 2),
                    child: Text(
                      'Enquire',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.2,
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
              height: MediaQuery.of(context).size.height * 0.25,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                    child: Text(
                      'Enquire through',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
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
                            _sendSMS(
                                'Code: $code\nHi, I\'d like to enquire about this rug.',
                                ['+60123372788']);
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
                            _launchWhatsapp(code);
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

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
  }

  void _launchWhatsapp(var code) async {
    String phoneNumber = '60123372788';
    String message =
        Uri.encodeFull('Code: $code\nHi, I\'d like to enquire about this rug.');
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      Fluttertoast.showToast(
          msg: "Could not launch Whatsapp",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      throw 'Could not launch $whatsappUrl';
    }
  }
}
