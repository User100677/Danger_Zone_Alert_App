import 'package:danger_zone_alert/auth/screens/register.dart';
import 'package:danger_zone_alert/auth/widgets/title_text.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  buttonStyle: kWhiteButtonStyle,
                  textColor: Colors.lightBlueAccent,
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
                RoundedRectangleButton(
                  buttonText: 'Sign up',
                  buttonStyle: kLightBlueButtonStyle,
                  textColor: Colors.white,
                  onPressed: () =>
                      Navigator.pushNamed(context, RegisterScreen.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
