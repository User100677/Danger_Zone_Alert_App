import 'package:danger_zone_alert/auth/screens/forgot_password.dart';
import 'package:danger_zone_alert/map/widgets/search_bar.dart';
import 'package:danger_zone_alert/rating/new_rating.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/screens/register.dart';
import 'auth/screens/sign_in.dart';
import 'auth/screens/welcome.dart';
import 'blocs/application_bloc.dart';
import 'models/user.dart';

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
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error initialization");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(providers: [
              StreamProvider<UserModel?>.value(
                  value: AuthService().user,
                  initialData: null,
                  catchError: null),
              ChangeNotifierProvider.value(value: ApplicationBloc(context)),
              ChangeNotifierProvider(create: (_) => SearchModel()),
            ], child: const Wrapper());
            // );
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        RatingQuestionsList.id: (context) => const RatingQuestionsList(),
      },
    );
  }
}

/*
Firebase Account Credentials:
Email: DangerZoneAlertGroup5a@gmail.com
Password: group5asegp
*/
