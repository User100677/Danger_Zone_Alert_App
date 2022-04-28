import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:danger_zone_alert/widget_view.dart';
import 'package:flutter/material.dart';

// This class is used to build reset users password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenController createState() =>
      _ForgotPasswordScreenController();
}

// Forgot Password Screen's WidgetView with reset password logic
class _ForgotPasswordScreenController extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailIncorrect = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future handleResetPasswordPressed() async {
    String email = _emailController.text.trim();

    setState(() => _isEmailIncorrect = false);

    if (_formKey.currentState!.validate()) {
      dynamic result = await _authService.sendPasswordResetEmail(email);

      if (result == null) {
        setState(() {
          _isEmailIncorrect = true;
        });
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) => _ForgotPasswordScreenView(this);
}

// Forgot Password's Screen's View
class _ForgotPasswordScreenView
    extends WidgetView<ForgotPasswordScreen, _ForgotPasswordScreenController> {
  const _ForgotPasswordScreenView(_ForgotPasswordScreenController state)
      : super(state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      // Second container that contains the Title, Email text field & Reset password button
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        // Title
        child: Column(
          children: <Widget>[
            const Text('Reset your password',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 24.0, color: Colors.lightBlueAccent)),
            const SizedBox(height: 16.0),
            // Email Text Field
            Form(
                key: state._formKey,
                child: EmailTextField(
                    emailController: state._emailController,
                    isEmailIncorrect: state._isEmailIncorrect,
                    emailIncorrectText: "Email doesn't exist")),
            // Reset password button
            RoundedRectangleButton(
                buttonText: 'RESET PASSWORD',
                buttonStyle: kLightBlueButtonStyle,
                textColor: Colors.white,
                onPressed: () => state.handleResetPasswordPressed()),
          ],
        ),
      ),
    );
  }
}
