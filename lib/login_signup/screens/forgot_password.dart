import 'package:danger_zone_alert/login_signup/components/email_text_field.dart';
import 'package:danger_zone_alert/login_signup/components/rounded_rectangle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "forgot_password_screen";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  late bool _isEmailEmpty;
  late bool _isEmailIncorrect;

  @override
  void initState() {
    super.initState();
    _isEmailEmpty = false;
    _isEmailIncorrect = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // First container that represent the grey shade
    return Container(
      color: const Color(0xff757575),
      // Second container that contains the Title, Email text field & Reset password button
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // Title
        child: Column(
          children: <Widget>[
            const Text(
              'Reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            // Email Text Field
            EmailTextField(
              emailController: _emailController,
              isEmailEmpty: _isEmailEmpty,
              isEmailIncorrect: _isEmailIncorrect,
              emailIncorrectText: "Email doesn't exist!",
            ),
            // Reset password button
            RoundedRectangleButton(
                buttonText: 'RESET PASSWORD',
                buttonColor: Colors.lightBlueAccent,
                buttonOutlineColor: Colors.lightBlueAccent,
                pressedColor: Colors.white,
                textColor: Colors.white,
                onPressed: () async {
                  if (_emailController.text.isEmpty) {
                    setState(() {
                      _isEmailEmpty = _emailController.text.isEmpty;
                    });
                  } else {
                    setState(() {
                      _isEmailEmpty = false;
                      _isEmailIncorrect = false;
                    });
                    try {
                      await _auth.sendPasswordResetEmail(
                          email: _emailController.text.trim());

                      setState(() {
                        Navigator.pop(context);
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _isEmailIncorrect = true;
                      });
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
