import 'dart:ui';

import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Circle> areaCircles = [];
List<Area> areaList = [];

class Area {
  LatLng latLng;
  double rating;
  int totalUsers;
  Color color;
  List<Comment> comment = [];

  Area(
      {required this.latLng,
      required this.rating,
      required this.totalUsers,
      required this.color}) {
    areaCircles.add(Circle(
      // Id is unique for each circle in the _circles and the the index is basically the index. Ex: 0, 1, 2 ...
      circleId: CircleId((latLng).toString()),
      center: latLng,
      radius: kAreaRadius,
      strokeWidth: 10,
      strokeColor: color,
      fillColor: color.withOpacity(0.7),
      consumeTapEvents: false,
    ));
  }
}

class Comment {
  String id;
  int likes;
  int dislikes;
  String content;
  String email;
  DateTime dateTime;

  Comment({
    required this.id,
    required this.likes,
    required this.dislikes,
    required this.content,
    required this.email,
    required this.dateTime,
  });
}
