// Abstract user model
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  // User's unique id
  final String uid;
  LatLng? _latLng;

  bool? _access;

  UserModel({required this.uid});

  get latLng => _latLng;

  void setLatLng(LatLng? value) => _latLng = value;

  bool? get access => _access;

  set setAccess(bool value) => _access = value;
}
