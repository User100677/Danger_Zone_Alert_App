import 'dart:convert' as convert;

import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/models/place_detail.dart';
import 'package:danger_zone_alert/models/place_search.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  static const key = kApiKey;

  // for autocomplete functionality
  static Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:my&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  // For on tap functionality
  static Future<PlaceDetail> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&components=country:my&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return PlaceDetail.fromJson(jsonResult);
  }
}
