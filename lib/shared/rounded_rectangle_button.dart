import 'package:flutter/material.dart';

class RoundedRectangleButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color buttonOutlineColor;
  final Color textColor;
  final Color pressedColor;
  final Function() onPressed;

  const RoundedRectangleButton(
      {Key? key,
        required this.buttonText,
        required this.buttonColor,
        required this.buttonOutlineColor,
        required this.pressedColor,
        required this.textColor,
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
            style: OutlinedButton.styleFrom(
              primary: pressedColor,
              backgroundColor: buttonColor,
              elevation: 5,
              side: BorderSide(
                color: buttonOutlineColor,
                style: BorderStyle.solid,
                width: 1,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
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
