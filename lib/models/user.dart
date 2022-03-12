// Abstract user model
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  // User's unique id
  final String uid;
  LatLng? _latLng;
  bool? _access;
  List<RatedArea> ratedAreas = [];

  UserModel({required this.uid});

  get latLng => _latLng;
  bool? get access => _access;
  void setLatLng(LatLng? value) => _latLng = value;
  set setAccess(bool value) => _access = value;
}

class RatedArea {
  LatLng latLng;
  double rating;
  List<CommentedArea> commentedArea = [];

  RatedArea({required this.latLng, this.rating = 0});
}

class CommentedArea {
  bool isLike;
  CommentedArea({required this.isLike});
}
