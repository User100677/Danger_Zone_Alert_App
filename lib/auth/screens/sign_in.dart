import 'package:danger_zone_alert/auth/screens/register.dart';
import 'package:danger_zone_alert/auth/widgets/button_divider.dart';
import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/password_text_field.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenController createState() => _LoginScreenController();
}

// Sign In Screen's WidgetView with sign in logic
class _LoginScreenController extends State<LoginScreen> {
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

    setState(() => _isEmailIncorrect = false);

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      dynamic result =
          await _authService.signInWithEmailAndPassword(email, password);

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
  }

  @override
  Widget build(BuildContext context) => _LoginScreenView(this);
}

// Sign In Screen's View
class _LoginScreenView extends WidgetView<LoginScreen, _LoginScreenController> {
  const _LoginScreenView(_LoginScreenController state) : super(state);

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
                key: state._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    EmailTextField(
                      emailController: state._emailController,
                      isEmailIncorrect: state._isEmailIncorrect,
                      emailIncorrectText: "Incorrect email or password",
                    ),
                    PasswordTextField(
                      passwordController: state._passwordController,
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
                      buttonText: kSignInText,
                      buttonStyle: kLightBlueButtonStyle,
                      textColor: Colors.white,
                      onPressed: () => state.handleLoginPressed(),
                    ),
                    buildButtonDivider(),
                    // Sign up button
                    RoundedRectangleButton(
                      buttonText: kSignUpText,
                      buttonStyle: kWhiteButtonStyle,
                      textColor: Colors.grey,
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, RegisterScreen.id),
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
