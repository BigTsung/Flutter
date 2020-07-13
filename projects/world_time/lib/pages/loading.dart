import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String time = 'loading';

  void setupWorldTime() async {
    WorldTime instance =
        WorldTime(location: 'taipei', flag: 'ta iwan.jpg', url: 'Asia/Taipei');
    await instance.getTime();

    Navigator.pushNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDaytime': instance.isDaytime
    });

    // print(instance.time);

    // setState(() {
    //   time = instance.time;
    // });
  }

  void getData() async {
    Response response =
        await get('https://jsonplaceholder.typicode.com/todos/1');
    Map jsonData = jsonDecode(response.body);
    // print(jsonData);
    // print(jsonData['title']);
    // print(jsonData['completed']);
  }

  @override
  void initState() {
    super.initState();
    // print('init state');
    // getData();
    setupWorldTime();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: SpinKitCubeGrid(
            color: Colors.white,
            size: 50.0,
          ),
        ));
  }
}
