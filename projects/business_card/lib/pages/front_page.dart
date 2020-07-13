import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Front_Page extends StatefulWidget {
  Front_Page({Key key}) : super(key: key);

  @override
  _Front_PageState createState() => _Front_PageState();
}

class _Front_PageState extends State<Front_Page> {
  @override
  Widget build(BuildContext context) {
    var deviceInfo = MediaQuery.of(context);
    // print(deviceInfo);
    double screenHeight = deviceInfo.size.height;
    double screenWidth = deviceInfo.size.width;

    String companyOfficialWeb = 'https://www.aemass.com/';
    String jobTitle = 'Software Engineer';
    String nameChinese = '邱昱璁';
    String nameEnglish = 'Anson Chiu';
    String phoneNumber = '0919xxxxxx';
    String email = 'anson@aexxxx.com';
    String textAddress = '臺北市大安區xxxxxxxxxx';
    String mapAddressUrl =
        'https://www.google.com/maps/place/106%E5%8F%B0%E5%8C%97%E5%B8%82%E5%A4%A7%E5%AE%89%E5%8D%80%E4%BB%81%E6%84%9B%E8%B7%AF%E5%9B%9B%E6%AE%B534%E8%99%9F/@25.0376287,121.5445262,17.02z/data=!4m5!3m4!1s0x3442abd1b90caf7d:0x58fda1f5e21f4033!8m2!3d25.0376304!4d121.5467245';
    String taxID = '828xxxxx';

    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SafeArea(
        child: Container(
            child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(screenWidth / 8, 0, 0, 0),
              alignment: Alignment.bottomLeft,
              // color: Colors.amber,
              height: screenHeight / 4 * 1,
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset('assets/AemassBanner_1024_light.png'),
                    iconSize: 110,
                    onPressed: () async {
                      openBrowserByURL(companyOfficialWeb);
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'AEMASS',
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 35,
                        fontFamily: "Roboto",
                        letterSpacing: 2),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(screenWidth / 4, 20, 0, 0),
              alignment: Alignment.topLeft,
              // color: Colors.green,
              height: screenHeight / 4 * 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    jobTitle,
                    style: TextStyle(
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2,
                        fontFamily: "Oswald"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        nameChinese,
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.normal,
                            fontSize: 30,
                            letterSpacing: 2,
                            fontFamily: "Oswald"),
                      ),
                      SizedBox(width: 16),
                      Text(
                        nameEnglish,
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontWeight: FontWeight.normal,
                            fontSize: 21,
                            letterSpacing: 2,
                            fontFamily: "Oswald"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton.icon(
                          onPressed: () async {
                            makeAPhoneCall(phoneNumber);
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Colors.grey[200],
                          ),
                          label: Text(phoneNumber,
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontFamily: "Oswald"))),
                      FlatButton.icon(
                          onPressed: () async {
                            sendAEmail(email);
                          },
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey[200],
                          ),
                          label: Text(email,
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontFamily: "Oswald"))),
                      FlatButton.icon(
                          onPressed: () async {
                            openBrowserByURL(mapAddressUrl);
                          },
                          icon: Icon(
                            Icons.home,
                            color: Colors.grey[200],
                          ),
                          label: Text(textAddress,
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontFamily: "Oswald"))),
                      FlatButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.payment,
                            color: Colors.grey[200],
                          ),
                          label: Text(taxID,
                              style: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontFamily: "Oswald"))),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              alignment: Alignment.topLeft,
              color: Colors.grey[500],
              height: screenHeight / 15,
              child: null,
            ),
          ],
        )),
      ),
    );
  }
}

void openBrowserByURL(String url) async {
  print('openBrowserByURL: $url');
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false);
  } else {
    throw 'Could not launch $url';
  }
}

void makeAPhoneCall(String phoneNumber) async {
  print('makePhoneCall: $phoneNumber');
  String telephoneUrl = "tel:+$phoneNumber";
  if (await canLaunch(telephoneUrl)) {
    await launch(telephoneUrl);
  } else {
    throw "Can't phone that number.";
  }
}

void sendAEmail(String emailAddress) async {
  String email = 'mailto:' + emailAddress;
  if (await canLaunch(email)) {
    await launch(email);
  } else {
    throw 'Could not Email';
  }
}
