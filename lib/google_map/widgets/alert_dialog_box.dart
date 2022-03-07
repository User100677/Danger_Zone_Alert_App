import 'package:flutter/material.dart';

void showAlertDialog(context, String action) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text(
                  'Location selected is too far from your current location to ' +
                      action +
                      '.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ]));
}
