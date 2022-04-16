import 'package:danger_zone_alert/auth/widgets/button_divider.dart';
import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/password_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/title_text.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  final Function() toggleView;

  const SignInScreen({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInScreenController createState() => _SignInScreenController();
}

// Sign In Screen's WidgetView with sign in logic
class _SignInScreenController extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailIncorrect = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future handleLoginPressed() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isEmailIncorrect = false;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      dynamic result =
          await _authService.signInWithEmailAndPassword(email, password);

      if (result == null) {
        setState(() {
          _isEmailIncorrect = true;
          _passwordController.clear();
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  handleResetPasswordPressed() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const ForgotPasswordScreen())));
  }

  @override
  Widget build(BuildContext context) => _LoginScreenView(this);
}

// Sign In Screen's View
class _LoginScreenView
    extends WidgetView<SignInScreen, _SignInScreenController> {
  const _LoginScreenView(_SignInScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      resizeToAvoidBottomInset: false,

      // Loading Indicator
      body: ModalProgressHUD(
        inAsyncCall: state._isLoading,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    // Display the logo on the login screen page
                    SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          'assets/images/icon.png',
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 10),
                    const TitleText(
                        text: 'Danger Zone Alert',
                        textSize: 40.0,
                        textColor: Colors.white,
                        textWeight: FontWeight.bold,
                        textAlign: TextAlign.center),
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
                      topRight: Radius.circular(20.0))),
              child: Form(
                key: state._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    const Text('Login account',
                        style: TextStyle(
                            fontFamily: 'Agne',
                            fontSize: 24.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    const SizedBox(height: 12),
                    EmailTextField(
                        emailController: state._emailController,
                        isEmailIncorrect: state._isEmailIncorrect,
                        emailIncorrectText: "Incorrect email or password"),
                    PasswordTextField(
                        passwordController: state._passwordController),
                    // Forgot password button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory),
                          child: Text('Forgot password?',
                              style: TextStyle(
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.8),
                                  fontSize: 12.0)),
                          onPressed: () => state.handleResetPasswordPressed(),
                        ),
                      ],
                    ),
                    // Login button
                    RoundedRectangleButton(
                        buttonText: kSignInText,
                        buttonStyle: kLightBlueButtonStyle,
                        textColor: Colors.white,
                        onPressed: () => state.handleLoginPressed()),
                    buildButtonDivider(),
                    // Sign up button
                    RoundedRectangleButton(
                      buttonText: kSignUpText,
                      buttonStyle: kWhiteButtonStyle,
                      textColor: Colors.grey,
                      onPressed: () => widget.toggleView(),
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
