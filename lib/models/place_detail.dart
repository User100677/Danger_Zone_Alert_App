// This class is created by serializers from JSON data to work with data quicker & safer
// Example JSON data link: https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJi64-lo9CzDERNZz9FqNZk-A&key=YOURAPIKEY

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetail {
  final Geometry geometry;
  final String name;
  final String vicinity;

  PlaceDetail(
      {required this.geometry, required this.name, required this.vicinity});

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = Location.fromJson(parsedJson['location']);
}

class Location {
  final LatLng latLng;

  Location({required this.latLng});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Location(latLng: LatLng(parsedJson['lat'], parsedJson['lng']));
  }
}
