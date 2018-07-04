import 'package:flutter/material.dart';
import 'package:restaurant_app/Restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

Restaurant restaurant;

class RestaurantPage extends StatefulWidget {
  _RestaurantPageState rP = new _RestaurantPageState();
  @override
  _RestaurantPageState createState() => rP;

  RestaurantPage(Restaurant r) {
    restaurant = r;
  }
}

class _RestaurantPageState extends State<RestaurantPage> {
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
  }

  //@src https://pub.dartlang.org/packages/url_launcher#-readme-tab-
  _launchURL(link) async {
  String url = link;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  //@src https://flutter.io/tutorials/layout/
  @override
  Widget build(BuildContext context) {
    GestureDetector buildButtonColumn(IconData icon, String label) {
      Color color = Colors.white;

      return GestureDetector(
          onTap: () {
            _launchURL('https://www.google.com/maps/search/?api=1&query=${restaurant.address}');
          }, child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Icon(icon, color: color),
            ),
          Text(
                label,
                style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
        ],
      )
      );
    }

    Widget buttonSection = Container(
      padding: const EdgeInsets.only(top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.call, 'CALL'),
          buildButtonColumn(Icons.near_me, 'ROUTE'),
          buildButtonColumn(Icons.share, 'SHARE'),
        ],
      ),
    );

  Widget textSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Text(restaurant.id),
      );

    double width =  MediaQuery.of(context).size.width;
    double height =  (MediaQuery.of(context).size.height/4);
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView(
          children: [
            new Container(
              width: width,
              height: height,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(20.0),
                color: const Color(0xff7c94b6),
                image: new DecorationImage(
                  image: new NetworkImage(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=${width.round()}&photoreference=${restaurant.photoReference}&key=AIzaSyA7C9zgb1ORXIoFwMW8eDw0TIHjsKnyQ2c"),
                  fit: BoxFit.cover,
                  ),
                ),
              ),
              buttonSection,
              textSection,
            ],
       )
    );
  }
}


