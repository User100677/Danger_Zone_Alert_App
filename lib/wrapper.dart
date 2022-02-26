import 'package:danger_zone_alert/auth/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'google_map/screen/google_map.dart';
import 'models/user.dart';

/* This widget decide whether to load WelcomeScreen widget or GoogleMapScreen widget
   depending on the value of the user. A signed in user will contain a UserModel object
   and null if otherwise. */

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assign userModel after log in
    final user = Provider.of<UserModel?>(context);

    // return either Home or Authenticate widget
    return user == null ? WelcomeScreen() : const GoogleMapScreen();
  }
}
