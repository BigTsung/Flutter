import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Back_Page extends StatefulWidget {
  Back_Page({Key key}) : super(key: key);

  @override
  _Back_PageState createState() => _Back_PageState();
}

class _Back_PageState extends State<Back_Page> {
  @override
  Widget build(BuildContext context) {
    var deviceInfo = MediaQuery.of(context);
    double screenHeight = deviceInfo.size.height;
    double screenWidth = deviceInfo.size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Responsive Layout'),
      ),
      body: OrientationLayoutBuilder(
          portrait: (context) => portraitLayout(screenWidth, screenHeight),
          landscape: (context) => landscapeLayout(screenWidth, screenHeight)),
    );
  }
}

Widget portraitLayout(double width, double height) {
  return Container(
    alignment: Alignment.topLeft,
    color: Colors.green,
    width: width,
    height: height,
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            spacing: 5,
            children: <Widget>[
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 100,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 150,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 70,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 80,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 110,
                  onPressed: null,
                ),
              ),
              // Text('1', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('2', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('3', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('4', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            spacing: 5,
            children: <Widget>[
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 100,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 150,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 70,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 80,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 110,
                  onPressed: null,
                ),
              ),
              // Text('1', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('2', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('3', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('4', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget landscapeLayout(double width, double height) {
  return Container(
    alignment: Alignment.topLeft,
    color: Colors.green,
    width: width,
    height: height,
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            spacing: 5,
            children: <Widget>[
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 100,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 150,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 70,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 80,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 110,
                  onPressed: null,
                ),
              ),
              // Text('1', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('2', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('3', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('4', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            spacing: 5,
            children: <Widget>[
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 100,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 150,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 70,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 80,
                  onPressed: null,
                ),
              ),
              Container(
                color: Colors.amber,
                child: IconButton(
                  icon: Icon(Icons.android),
                  iconSize: 110,
                  onPressed: null,
                ),
              ),
              // Text('1', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('2', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('3', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('4', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
              // Text('5', style: TextStyle(color: Colors.grey[700], fontSize: 50)),
            ],
          ),
        ),
      ],
    ),
  );
}
