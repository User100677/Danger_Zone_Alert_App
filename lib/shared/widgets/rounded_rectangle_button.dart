import 'package:flutter/material.dart';

class RoundedRectangleButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final ButtonStyle buttonStyle;
  final Function() onPressed;

  const RoundedRectangleButton(
      {Key? key,
      required this.buttonText,
      required this.textColor,
      required this.buttonStyle,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48.0,
        child: ButtonTheme(
          minWidth: 200.0,
          child: OutlinedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
