import 'package:flutter/material.dart';

// Error snackBar when permission is denied
errorSnackBar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(milliseconds: 4000),
  ));
}
