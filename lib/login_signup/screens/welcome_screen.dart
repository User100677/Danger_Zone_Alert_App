import 'package:danger_zone_alert/circle_area/geolocator_service.dart';
import 'package:danger_zone_alert/login_signup/components/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/login_signup/components/title_text.dart';
import 'package:danger_zone_alert/login_signup/screens/signup_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final geolocatorService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    geolocatorService.determinePosition(context);
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  TitleText(
                    text: 'Danger Zone\nAlert',
                    textSize: 40.0,
                    textColor: Colors.white,
                    textWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedRectangleButton(
                  buttonText: 'Log in',
                  buttonColor: Colors.white,
                  buttonOutlineColor: Colors.white,
                  pressedColor: Colors.lightBlueAccent,
                  textColor: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                RoundedRectangleButton(
                  buttonText: 'Sign up',
                  buttonColor: Colors.lightBlueAccent,
                  buttonOutlineColor: Colors.white,
                  pressedColor: Colors.white,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
