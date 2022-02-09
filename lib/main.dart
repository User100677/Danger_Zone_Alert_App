import 'package:danger_zone_alert/authentication/screens/forgot_password.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './google_map.dart';
import 'authentication/screens/register.dart';
import 'authentication/screens/sign_in.dart';
import 'authentication/screens/welcome.dart';
import 'models/user.dart';

/*
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
            return StreamProvider<UserModel?>.value(
              value: AuthService().user,
              initialData: null,
              catchError: null,
              child: const Wrapper(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        GoogleMapScreen.id: (context) => const GoogleMapScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
        Register.id: (context) => const Register(),
      },
    );
  }
}
