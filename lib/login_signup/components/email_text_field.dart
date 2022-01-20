import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController emailController;
  bool isEmailEmpty;
  bool isEmailIncorrect;

  EmailTextField(
      {Key? key,
      required this.emailController,
      required this.isEmailEmpty,
      required this.isEmailIncorrect})
      : super(key: key);

  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: widget.emailController,
        keyboardType: TextInputType.emailAddress,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.email_sharp,
            size: 20.0,
          ),
          hintText: 'Email',
          contentPadding: const EdgeInsets.all(10.0),
          errorText: widget.isEmailEmpty
              ? "Field can't be empty!"
              : widget.isEmailIncorrect
                  ? "Incorrect email or password"
                  : null,
        ),
      ),
    );
  }
}
