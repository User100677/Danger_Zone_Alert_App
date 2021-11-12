import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Radius {
  List<Circle> _circles = [];
  // Keep track of the circle index
  int circleIndex = 0;

  void addCircle(LatLng tappedPoint) {
    _circles.add(
      Circle(
        circleId: CircleId(tappedPoint.toString()),
        center: tappedPoint,
        radius: 100,
        strokeWidth: 2,
        fillColor: const Color.fromRGBO(102, 51, 153, .5),
        consumeTapEvents: true,
        onTap: () {},
      ),
    );

    // Print the length of the list and the id of the created circle
    print("Length of circle: ${_circles.length}");
    print("ID of created circle: ${getCircleId()}");
    circleIndex++;
  }

  List<Circle> get getCircles {
    return _circles;
  }

  set setCircles(List<Circle> circles) {
    _circles = circles;
  }

  CircleId getCircleId() {
    return _circles[circleIndex].circleId;
  }

  void printInfo() {
    print("Length of circle: ${_circles.length}");
    print("ID of created circle: ${getCircleId()}");
  }
}
