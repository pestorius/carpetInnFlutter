import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  AboutUsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageWidth = 45.0;
    double gapBetweenIcons = 13.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
              fontFamily: 'OpenSans', color: Colors.black, fontSize: 22.0),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'),
              ),
              Text(
                'Tel: +603 4265 2788\nHP: +6012 337 2788',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Website',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'),
                ),
              ),
              Text(
                'carpetinn.my',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 18.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Social Media',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL('https://www.facebook.com/carpetinn.my/');
                      },
                      child: Image.asset(
                        'assets/facebook.png',
                        width: imageWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: gapBetweenIcons),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL('https://www.instagram.com/carpetinn.my/');
                      },
                      child: Image.asset(
                        'assets/instagram.png',
                        width: imageWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: gapBetweenIcons),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL('https://twitter.com/gauharaslam');
                      },
                      child: Image.asset(
                        'assets/twitter.png',
                        width: imageWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: gapBetweenIcons),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            'https://business.google.com/b/117720008708351337832/edit/l/15002181132364817109');
                      },
                      child: Image.asset(
                        'assets/google-plus.png',
                        width: imageWidth,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: gapBetweenIcons),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL('https://www.pinterest.com/gauharaslam/');
                      },
                      child: Image.asset(
                        'assets/pinterest.png',
                        width: imageWidth,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Address',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'),
                ),
              ),
              Text(
                'G-07, Ground Floor, Plaza Flamingo, (next to Flamingo Hotel) Jalan Hulu Kelang, 68000 Ampang, Selangor, Malaysia',
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Navigate to Gallery',
                  style: TextStyle(fontSize: 24.0, fontFamily: 'OpenSans'),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                        onTap: () {
                          _launchURL(
                              'https://www.google.com.my/maps/place/CARPET+INN,+(owned+by:Petal+World+Sdn.Bhd.)/@3.1615474,101.7486903,17z/data=!4m5!3m4!1s0x31cc37a7c25d31cd:0x1abbb830f620928f!8m2!3d3.161542!4d101.750879');
                        },
                        child: Image.asset(
                          'assets/google-maps.png',
                          width: imageWidth,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: gapBetweenIcons),
                    child: GestureDetector(
                        onTap: () {
                          _launchURL(
                              'https://www.waze.com/livemap/directions/malaysia/selangor/ampang/carpet-inn,-(owned-bypetal-world-sdn.bhd.)?place=ChIJzTFdwqc3zDERj5Ig9jC4uxo');
                        },
                        child: Image.asset(
                          'assets/waze.png',
                          width: imageWidth,
                        )),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    width: 200.0,
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '* Icons made by Pixel perfect & Freepik from www.flaticon.com',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 11.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
