import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController emailController;
  bool isEmailIncorrect;
  String emailIncorrectText;

  EmailTextField(
      {Key? key,
      required this.emailController,
      required this.isEmailIncorrect,
      required this.emailIncorrectText})
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
          errorText: widget.isEmailIncorrect ? widget.emailIncorrectText : null,
        ),
        validator: (String? value) =>
            value!.isEmpty ? "Field can't be empty" : null,
      ),
    );
  }
}
