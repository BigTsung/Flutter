import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String flag;
  String url;
  bool isDaytime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      // print(data);

      String dateTime = data['datetime'];
      String utcOffset = data['utc_offset'].substring(1, 3);

      // print(dateTime);
      // print(utcOffset);

      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(utcOffset)));
      print('now');
      print(now);
      isDaytime = now.hour > 6 && now.hour < 19 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
