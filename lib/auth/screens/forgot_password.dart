import 'package:danger_zone_alert/auth/widgets/email_text_field.dart';
import 'package:danger_zone_alert/services/auth.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "forgot_password_screen";
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late bool _isEmailIncorrect;

  @override
  void initState() {
    super.initState();
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
            Form(
              key: _formKey,
              child: EmailTextField(
                emailController: _emailController,
                isEmailIncorrect: _isEmailIncorrect,
                emailIncorrectText: "Email doesn't exist",
              ),
            ),
            // Reset password button
            RoundedRectangleButton(
                buttonText: 'RESET PASSWORD',
                buttonColor: Colors.lightBlueAccent,
                buttonOutlineColor: Colors.lightBlueAccent,
                pressedColor: Colors.white,
                textColor: Colors.white,
                onPressed: () async {
                  String email = _emailController.text.trim();

                  setState(() => _isEmailIncorrect = false);

                  if (_formKey.currentState!.validate()) {
                    // setState(() => _isLoading = true);

                    dynamic result =
                        await _authService.sendPasswordResetEmail(email);

                    if (result == null) {
                      setState(() {
                        _isEmailIncorrect = true;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                    // setState(() => _isLoading = false);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
