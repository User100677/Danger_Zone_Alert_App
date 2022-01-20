import 'package:danger_zone_alert/google_map.dart';
import 'package:danger_zone_alert/login_signup/components/button_divider.dart';
import 'package:danger_zone_alert/login_signup/components/email_text_field.dart';
import 'package:danger_zone_alert/login_signup/components/password_text_field.dart';
import 'package:danger_zone_alert/login_signup/components/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/login_signup/components/title_text.dart';
import 'package:danger_zone_alert/login_signup/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// TODO: Forgot password functionalities

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      TitleText(
                        text: 'Welcome\nBack',
                        textSize: 32.0,
                        textColor: Colors.white,
                        textWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 16.0,
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
                      passwordController: _passwordController,
                      passwordVisible: _passwordVisible,
                      isPasswordEmpty: _isPasswordEmpty,
                      isPasswordIncorrect: _isPasswordIncorrect,
                    ),
                    // Forgot password Widget
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     TextButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //         splashFactory: NoSplash.splashFactory,
                    //       ),
                    //       child: Text(
                    //         'Forgot password?',
                    //         style: TextStyle(
                    //           color: Colors.lightBlueAccent.withOpacity(0.8),
                    //           fontSize: 12.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    RoundedRectangleButton(
                      buttonText: 'Log in',
                      buttonColor: Colors.blueAccent,
                      buttonOutlineColor: Colors.blueAccent,
                      pressedColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          setState(() {
                            _isEmailEmpty = _emailController.text.isEmpty;
                            _isPasswordEmpty = _passwordController.text.isEmpty;
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
                            final user = await _auth.signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());

                            if (user != null) {
                              Navigator.popAndPushNamed(
                                  context, GoogleMapScreen.id);
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _isEmailIncorrect = true;
                              _isPasswordIncorrect = true;
                              _isLoading = false;
                              _passwordController.clear();
                            });
                          }
                        }
                      },
                    ),
                    const ButtonDivider(),
                    RoundedRectangleButton(
                      buttonText: 'Sign up',
                      buttonColor: Colors.white,
                      buttonOutlineColor: Colors.grey,
                      pressedColor: Colors.blueAccent,
                      textColor: Colors.grey,
                      onPressed: () {
                        Navigator.popAndPushNamed(context, SignupScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
