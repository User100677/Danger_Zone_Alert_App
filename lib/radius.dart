import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Radius {
  List<Circle> _circles = [];


  void listCircle() {
    _circles.add(
      Circle(
        circleId: CircleId("0"),
        center: LatLng(3.1390, 101.6869),
        radius: 500,
        strokeWidth: 2,
        fillColor: Colors.red,
      ),
    );
  }

  List<Circle> get getCircles {
    return _circles;
  }

  void set setCircles(List<Circle> circles) {
    this._circles = circles;
  }

}
