import 'package:danger_zone_alert/auth/screens/sign_in.dart';
import 'package:danger_zone_alert/auth/widgets/button_divider.dart';
import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/password_text_field.dart';
import 'package:danger_zone_alert/auth/widgets/title_text.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  static String id = "sign_up_screen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenController createState() => _SignUpScreenController();
}

// Register Screen's WidgetView with sign up logic
class _SignUpScreenController extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailIncorrect = false;
  bool _isPasswordIncorrect = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
  }

  Future handleSignupPressed() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String reenterPassword = _reenterPasswordController.text.trim();

    setState(() {
      _isEmailIncorrect = false;
      _isPasswordIncorrect = false;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (password == reenterPassword) {
        dynamic result = await _authService.registerWithEmailAndPassword(
            email, reenterPassword);

        if (result == null) {
          setState(() {
            _isEmailIncorrect = true;
            _passwordController.clear();
            _reenterPasswordController.clear();
          });
        } else {
          await _authService.signInWithEmailAndPassword(email, reenterPassword);
          Navigator.pop(context);
        }
      } else {
        _isPasswordIncorrect = true;
        _reenterPasswordController.clear();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => _RegisterScreenView(this);
}

// Register Screen's View
class _RegisterScreenView
    extends WidgetView<SignUpScreen, _SignUpScreenController> {
  const _RegisterScreenView(_SignUpScreenController state) : super(state);

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
            // A container containing the Divider, Email & Password text field as well as SignIn & SignUp buttons
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
                    const Text('Create account',
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
                        emailIncorrectText: 'Please supply a valid email'),
                    PasswordTextField(
                        passwordController: state._passwordController,
                        isPasswordIncorrect: state._isPasswordIncorrect,
                        passwordIncorrectText: "Password doesn't match"),
                    PasswordTextField(
                        passwordController: state._reenterPasswordController,
                        isPasswordIncorrect: state._isPasswordIncorrect,
                        passwordHintText: "Re-enter password"),
                    // Signup button
                    RoundedRectangleButton(
                        buttonText: kSignUpText,
                        buttonStyle: kLightBlueButtonStyle,
                        textColor: Colors.white,
                        onPressed: () => state.handleSignupPressed()),
                    buildButtonDivider(),
                    // Login button
                    RoundedRectangleButton(
                        buttonText: kSignInText,
                        buttonStyle: kWhiteButtonStyle,
                        textColor: Colors.grey,
                        onPressed: () => Navigator.popAndPushNamed(
                            context, SignInScreen.id)),
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
