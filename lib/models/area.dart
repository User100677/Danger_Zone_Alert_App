import 'dart:ui';

import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Circle> areaCircles = [];
List<Area> areaList = [];

class Area {
  LatLng latLng;
  double rating;
  int rateCount;
  // TODO: Change the datatype of color from string to Colors
  // Colors color;
  String color;
  List<Comment> comment = [];

  Area(
      {required this.latLng,
      required this.rating,
      required this.rateCount,
      required this.color}) {
    areaCircles.add(Circle(
      // Id is unique for each circle in the _circles and the the index is basically the index. Ex: 0, 1, 2 ...
      circleId: CircleId((latLng).toString()),
      center: latLng,
      radius: kAreaRadius,
      strokeWidth: 0,
      fillColor: const Color.fromRGBO(255, 0, 0, .5),
      consumeTapEvents: false,
    ));
  }
}

class Comment {
  int likeNDislike;
  String text;
  String email;

  Comment(
      {required this.likeNDislike, required this.text, required this.email});
}
