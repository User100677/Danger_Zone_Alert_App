import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  // User's unique id
  final String uid;
  final String? email;
  LatLng? _latLng;
  bool? _access;
  List<RatedArea> ratedAreas = [];
  List<CommentedArea> commentedArea = [];

  UserModel({required this.uid, required this.email});

  get latLng => _latLng;
  bool? get access => _access;
  void setLatLng(LatLng value) => _latLng = value;
  set setAccess(bool value) => _access = value;
}

class RatedArea {
  LatLng latLng;
  double rating;

  RatedArea({required this.latLng, this.rating = 0});
}

class CommentedArea {
  String id;
  bool isLiked;
  bool isDisliked;

  CommentedArea(
      {required this.id, required this.isLiked, required this.isDisliked});
}
