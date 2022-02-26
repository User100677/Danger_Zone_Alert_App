import 'package:danger_zone_alert/auth/widgets/button_divider.dart';
import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/password_text_field.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'sign_in.dart';

class Register extends StatefulWidget {
  static String id = "register_screen";
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  late bool _isLoading;
  late bool _isEmailIncorrect;
  late bool _isPasswordIncorrect;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isEmailIncorrect = false;
    _isPasswordIncorrect = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        EmailTextField(
                          emailController: _emailController,
                          isEmailIncorrect: _isEmailIncorrect,
                          emailIncorrectText: 'Please supply a valid email',
                        ),
                      ],
                    ),
                    PasswordTextField(
                      passwordController: _passwordController,
                      isPasswordIncorrect: _isPasswordIncorrect,
                      passwordIncorrectText: "Password doesn't match",
                    ),
                    PasswordTextField(
                      passwordController: _reenterPasswordController,
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
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String reenterPassword =
                            _reenterPasswordController.text.trim();

                        setState(() {
                          _isEmailIncorrect = false;
                          _isPasswordIncorrect = false;
                        });
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          if (password == reenterPassword) {
                            dynamic result =
                                await _authService.registerWithEmailAndPassword(
                                    email, reenterPassword);

                            if (result == null) {
                              setState(() {
                                _isEmailIncorrect = true;
                                _passwordController.clear();
                                _reenterPasswordController.clear();
                              });
                            } else {
                              await _authService.signInWithEmailAndPassword(
                                  email, reenterPassword);
                              Navigator.pop(context);
                            }
                          } else {
                            _isPasswordIncorrect = true;
                            _reenterPasswordController.clear();
                          }
                          setState(() => _isLoading = false);
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
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, LoginScreen.id),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
