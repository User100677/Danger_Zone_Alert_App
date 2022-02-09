import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;
  bool isPasswordIncorrect;
  String passwordIncorrectText;
  String passwordHintText;

  bool passwordVisible = false;

  PasswordTextField({
    Key? key,
    required this.passwordController,
    this.isPasswordIncorrect = false,
    this.passwordIncorrectText = "",
    this.passwordHintText = "Password",
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: widget.passwordController,
        obscureText: !widget.passwordVisible,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock,
            size: 20.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              widget.passwordVisible ? Icons.visibility : Icons.visibility_off,
              size: 20.0,
            ),
            tooltip: "Show password",
            onPressed: () {
              setState(() {
                widget.passwordVisible = !widget.passwordVisible;
              });
            },
          ),
          hintText: widget.passwordHintText,
          errorText:
              widget.isPasswordIncorrect ? widget.passwordIncorrectText : null,
        ),
        validator: (String? value) => value!.length < 6
            ? 'Field must contain at least 6 characters'
            : null,
      ),
    );
  }
}
