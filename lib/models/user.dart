// Abstract user model
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  // Store the unique id of the user
  final String uid;
  // Latitude and Longitude of the user position
  LatLng? _latLng;

  UserModel({required this.uid});

  get latLng => _latLng;

  void setLatLng(LatLng? value) => _latLng = value;
}
