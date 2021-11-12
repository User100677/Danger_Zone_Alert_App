import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'radius.dart';

class DisplayDialog extends StatefulWidget {
  DisplayDialog(
      {required this.radius,
      required this.placemarkDescription,
      required this.placemarkLatLng,
      required this.state});

  final Radius radius;
  final String placemarkDescription;
  final LatLng placemarkLatLng;
  final Function state;

  @override
  _DisplayDialogState createState() => _DisplayDialogState();
}

class _DisplayDialogState extends State<DisplayDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.placemarkDescription),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Currently the function of rate/comment button is to create circle
              Expanded(
                child: SimpleDialogOption(
                  onPressed: () {
                    widget.radius.addCircle(widget.placemarkLatLng);
                    Navigator.pop(context);
                    widget.state();
                  },
                  child: const Text('Rate'),
                ),
              ),
              Container(
                width: 30,
              ),
              Expanded(
                child: SimpleDialogOption(
                  onPressed: () {
                    widget.radius.addCircle(widget.placemarkLatLng);
                    Navigator.pop(context);
                    widget.state();
                  },
                  child: const Text('Comment'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
