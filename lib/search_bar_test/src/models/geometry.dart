import 'package:danger_zone_alert/search_bar_test/src/models/location.dart';

class Geometry {
  final Location location;

  Geometry({required this.location});

  Geometry.fromJson(Map<dynamic, dynamic> parsedJson)
      : location = Location.fromJson(parsedJson['location']);
}
