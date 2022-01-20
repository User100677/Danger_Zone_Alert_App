import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'danger_area.dart';

class AreaDialog extends StatefulWidget {
  final DangerArea radius;
  final String placemarkDescription;
  final LatLng placemarkLatLng;
  final Function state;

  AreaDialog(
      {required this.radius,
      required this.placemarkDescription,
      required this.placemarkLatLng,
      required this.state});

  @override
  _AreaDialogState createState() => _AreaDialogState();
}

class _AreaDialogState extends State<AreaDialog> {
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
