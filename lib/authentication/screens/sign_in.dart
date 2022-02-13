import 'package:danger_zone_alert/authentication/components/button_divider.dart';
import 'package:danger_zone_alert/authentication/components/email_text_field.dart';
import 'package:danger_zone_alert/authentication/components/password_text_field.dart';
import 'package:danger_zone_alert/authentication/screens/forgot_password.dart';
import 'package:danger_zone_alert/authentication/screens/register.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _isLoading;
  late bool _isEmailIncorrect;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isEmailIncorrect = false;
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
                      'Welcome\nBack',
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
            // A container containing the Divider, Email & Password text field as well as SignUp & SignIn buttons
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                    EmailTextField(
                      emailController: _emailController,
                      isEmailIncorrect: _isEmailIncorrect,
                      emailIncorrectText: "Incorrect email or password",
                    ),
                    PasswordTextField(
                      passwordController: _passwordController,
                    ),
                    // Forgot password button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.lightBlueAccent.withOpacity(0.8),
                              fontSize: 12.0,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: const ForgotPasswordScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // Login button
                    RoundedRectangleButton(
                      buttonText: 'Log in',
                      buttonColor: Colors.lightBlueAccent,
                      buttonOutlineColor: Colors.lightBlueAccent,
                      pressedColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();

                        setState(() => _isEmailIncorrect = false);

                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          dynamic result = await _authService
                              .signInWithEmailAndPassword(email, password);

                          if (result == null) {
                            setState(() {
                              _isEmailIncorrect = true;
                              _passwordController.clear();
                            });
                          } else {
                            Navigator.pop(context);
                          }
                          setState(() => _isLoading = false);
                        }
                      },
                    ),
                    const ButtonDivider(),
                    // Signup button
                    RoundedRectangleButton(
                      buttonText: 'Sign up',
                      buttonColor: Colors.white,
                      buttonOutlineColor: Colors.grey,
                      pressedColor: Colors.lightBlueAccent,
                      textColor: Colors.grey,
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, Register.id),
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
