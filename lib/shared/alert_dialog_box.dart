import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

showAlertDialogBox(alertType, title, description, text1, context) {
  Alert(
    context: context,
    type: alertType,
    title: title,
    desc: description,
    content: Column(children: <Widget>[
      const SizedBox(height: 18.0),
      Text(text1, style: Theme.of(context).textTheme.caption),
    ]),
    buttons: [
      DialogButton(
        child: const Text(
          "Got it",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.lightBlueAccent,
        width: 120,
      ),
    ],
    style: const AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        animationDuration: Duration(milliseconds: 300),
        titleStyle: TextStyle(
            fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold),
        descStyle: TextStyle(fontSize: 16.0),
        descTextAlign: TextAlign.center),
  ).show();
}
