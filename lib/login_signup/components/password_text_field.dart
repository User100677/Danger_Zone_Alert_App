import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;
  bool passwordVisible;
  bool isPasswordEmpty;
  bool isPasswordIncorrect;
  String passwordIncorrectText;
  String passwordHintText;

  PasswordTextField({
    Key? key,
    required this.passwordController,
    required this.passwordVisible,
    required this.isPasswordEmpty,
    required this.isPasswordIncorrect,
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
          errorText: widget.isPasswordEmpty
              ? "Field can't be empty!"
              : widget.isPasswordIncorrect
                  ? widget.passwordIncorrectText
                  : null,
        ),
      ),
    );
  }
}
