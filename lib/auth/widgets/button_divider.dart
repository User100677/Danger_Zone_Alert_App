import 'package:flutter/material.dart';

@override
Widget buildButtonDivider() {
  const double kDividerMargin = 12.0;
  const double kDividerHeight = 25.0;
  const double kDividerThickness = 1.5;
  Color kDividerColor = Colors.grey.shade400;

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
