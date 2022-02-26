import 'package:flutter/material.dart';

class ButtonDivider extends StatelessWidget {
  const ButtonDivider({Key? key}) : super(key: key);

  static const double kDividerMargin = 12.0;
  static const double kDividerHeight = 25.0;
  static const double kDividerThickness = 1.5;
  static Color kDividerColor = Colors.grey.shade400;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: kDividerMargin),
            child: Divider(
              height: kDividerHeight,
              thickness: kDividerThickness,
              color: kDividerColor,
            ),
          ),
        ),
        const Text(
          'or',
          style: TextStyle(color: Colors.grey),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: kDividerMargin),
            child: Divider(
              height: kDividerHeight,
              thickness: kDividerThickness,
              color: kDividerColor,
            ),
          ),
        ),
      ],
    );
  }
}
