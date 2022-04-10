import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoModel {
  // User's unique id
  final String stateid;
  LatLng? _latLng;
  List<States> states = [];

InfoModel({required this.stateid});

  void setLatLng(LatLng value) => _latLng = value;
}
 class States{
  
  int robbery;
  int murder;
  int rape;
  int injury;
  String name ; 

  States(
      {
  
      required this.name,
      required this.murder,
      required this.rape,
      required this.injury,
      required this.robbery,
      });
}
