import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      required this.color});
}

class Comment {
  int likeNDislike;
  String text;
  String email;

  Comment(
      {required this.likeNDislike, required this.text, required this.email});
}
