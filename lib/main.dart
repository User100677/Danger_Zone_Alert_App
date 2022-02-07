import 'package:danger_zone_alert/login_signup/screens/forgot_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './google_map.dart';
import 'login_signup/screens/login_screen.dart';
import 'login_signup/screens/signup_screen.dart';
import 'login_signup/screens/welcome_screen.dart';

/*
Login using the following credentials for google account as firebase account is
linked with google account.

Firebase Account Credentials:
Email: DangerZoneAlertGroup5a@gmail.com
Password: group5asegp
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danger Zone Alert',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // The following line return the first screen of the app
            return const WelcomeScreen();
            // return GoogleMapScreen();
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        GoogleMapScreen.id: (context) => GoogleMapScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
      },
    );
  }
}
