import 'package:flutter/material.dart';
import 'package:business_card/pages/front_page.dart';
import 'package:business_card/pages/back_page.dart';

void main() => runApp(MaterialApp(initialRoute: '/front_page', routes: {
      '/front_page': (context) => Front_Page(),
      '/back_page': (context) => Back_Page()
    }));
