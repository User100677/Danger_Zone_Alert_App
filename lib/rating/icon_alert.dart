import 'package:flutter/material.dart';

class IconAlert extends StatelessWidget {
  const IconAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Welcome to the Rating Page!',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24.0),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      titlePadding: const EdgeInsets.all(12.0),
      contentPadding: const EdgeInsets.all(12.0),
      content: Wrap(
        children: const [
          Text(
              'The purpose of this feature is to let the user rate the safety level of an area based on the feature of safe city implemented by the government.',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),
              textAlign: TextAlign.center),
          Text('\n\n Let\'s Create a Safer Place Together!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19.0),
              textAlign: TextAlign.center),
          Text(
              '\n\n Hint: To clear out the rating of a question, click twice on the first star of the question.',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),
              textAlign: TextAlign.center),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', textAlign: TextAlign.center))
      ],
    );
  }
}
