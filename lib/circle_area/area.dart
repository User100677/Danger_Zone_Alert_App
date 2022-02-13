import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Area {
  final List<Circle> _circles = [];
  final double _circleRadius = 100.0;

  void addCircle(LatLng tappedPoint) {
    _circles.add(
      Circle(
        // Id is unique for each circle in the _circles and the the index is basically the index. Ex: 0, 1, 2 ...
        circleId: CircleId((_circles.length).toString()),
        center: tappedPoint,
        radius: _circleRadius,
        strokeWidth: 0,
        fillColor: const Color.fromRGBO(255, 0, 0, .5),
        consumeTapEvents: false,
        // onTap: () {
        //  print(tappedPoint);
        // },
      ),
    );
  }

  // Circle Radius 100.0 = 0.1km
  // Check if the tapPosition is within the circle
  bool isWithinCircle(double distance) =>
      (distance < (_circleRadius / 1000)) ? true : false;

  List<Circle> get circles => _circles;

  double get circleRadius => _circleRadius;
}
