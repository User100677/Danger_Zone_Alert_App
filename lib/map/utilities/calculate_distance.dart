import 'dart:math';

import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Algorithm to calculate the distance between 2 latLng
double calculateDistance(LatLng circle, LatLng tapLatLng) {
  const double pi = 3.1415926535897932;

  double lat1 = circle.latitude * pi / 180;
  double lat2 = tapLatLng.latitude * pi / 180;
  double lon1 = circle.longitude * pi / 180;
  double lon2 = tapLatLng.longitude * pi / 180;

  // Haversine formula
  double dlon = lon2 - lon1;
  double dlat = lat2 - lat1;
  double a =
      pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);

  // Radius of earth in km
  var radiusEarth = 6371;
  var b = 2 * asin(sqrt(a));

  // calculate the result
  return radiusEarth * b;
}

// Circle Radius 100.0 = 0.1km
// Check if the tapPosition is within the circle
bool isWithinCircle(double distance) =>
    (distance < (kAreaRadius / 1000)) ? true : false;
