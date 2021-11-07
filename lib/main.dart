import 'package:flutter/material.dart';
import './google_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danger Zone Alert',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home:  GoogleMapScreen(),
    );
  }
}

