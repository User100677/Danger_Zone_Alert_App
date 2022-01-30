import 'package:danger_zone_alert/google_map.dart';
import 'package:danger_zone_alert/login_signup/components/button_divider.dart';
import 'package:danger_zone_alert/login_signup/components/email_text_field.dart';
import 'package:danger_zone_alert/login_signup/components/password_text_field.dart';
import 'package:danger_zone_alert/login_signup/components/rounded_rectangle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static String id = "signup_screen";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _createPasswordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  late bool _isLoading;
  late bool _isEmailEmpty;
  late bool _isEmailIncorrect;
  late bool _passwordVisible;
  late bool _isPasswordEmpty;
  late bool _isPasswordIncorrect;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isEmailEmpty = false;
    _isEmailIncorrect = false;
    _passwordVisible = false;
    _isPasswordEmpty = false;
    _isPasswordIncorrect = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _createPasswordController.dispose();
    _reenterPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      resizeToAvoidBottomInset: false,
      // AppBar with arrow back button
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      // Loading Indicator
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Title Text
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Create\nAccount',
                      style: TextStyle(
                        fontFamily: 'Agne',
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            // A container containing the Divider, Email & Password text field as well as SignIn & SignUp buttons
            Container(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 24.0,
                right: 24.0,
                bottom: 16.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      EmailTextField(
                        emailController: _emailController,
                        isEmailEmpty: _isEmailEmpty,
                        isEmailIncorrect: _isEmailIncorrect,
                      ),
                    ],
                  ),
                  PasswordTextField(
                    passwordController: _createPasswordController,
                    passwordVisible: _passwordVisible,
                    isPasswordEmpty: _isPasswordEmpty,
                    isPasswordIncorrect: _isPasswordIncorrect,
                    passwordIncorrectText: "Password doesn't match",
                  ),
                  PasswordTextField(
                    passwordController: _reenterPasswordController,
                    passwordVisible: _passwordVisible,
                    isPasswordEmpty: _isPasswordEmpty,
                    isPasswordIncorrect: _isPasswordIncorrect,
                    passwordHintText: "Re-enter password",
                  ),
                  // Signup button
                  RoundedRectangleButton(
                    buttonText: 'Sign up',
                    buttonColor: Colors.lightBlueAccent,
                    buttonOutlineColor: Colors.lightBlueAccent,
                    pressedColor: Colors.white,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _createPasswordController.text.isEmpty ||
                          _reenterPasswordController.text.isEmpty) {
                        setState(() {
                          _isEmailEmpty = _emailController.text.isEmpty;
                          _isPasswordEmpty = true;
                        });
                      } else if (_createPasswordController.text !=
                          _reenterPasswordController.text) {
                        setState(() {
                          _isEmailEmpty = false;
                          _isPasswordEmpty = false;
                          _isPasswordIncorrect = true;
                          _createPasswordController.clear();
                          _reenterPasswordController.clear();
                        });
                      } else {
                        setState(() {
                          _isEmailEmpty = false;
                          _isPasswordEmpty = false;
                          _isEmailIncorrect = false;
                          _isPasswordIncorrect = false;
                          _isLoading = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password:
                                      _reenterPasswordController.text.trim());

                          if (newUser != null) {
                            Navigator.popAndPushNamed(
                                context, GoogleMapScreen.id);
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _isLoading = false;
                            _isEmailIncorrect = true;
                            _isPasswordIncorrect = false;
                            _createPasswordController.clear();
                            _reenterPasswordController.clear();
                          });
                        }
                      }
                    },
                  ),
                  const ButtonDivider(),
                  // Login button
                  RoundedRectangleButton(
                    buttonText: 'Log in',
                    buttonColor: Colors.white,
                    buttonOutlineColor: Colors.grey,
                    pressedColor: Colors.lightBlueAccent,
                    textColor: Colors.grey,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, LoginScreen.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
