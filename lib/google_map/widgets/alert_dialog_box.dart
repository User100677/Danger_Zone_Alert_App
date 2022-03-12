import 'package:flutter/material.dart';

void showAlertDialog(context, String alertText) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text(
                  alertText),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ]));
}
