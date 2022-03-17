import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String> getAddress(LatLng latLng) async {
  List<Placemark> placeMark = await placemarkFromCoordinates(
      latLng.latitude, latLng.longitude,
      localeIdentifier: 'ms_MY');

  return _parseAddress(placeMark[0]);
}

// This method format the address into String
String _parseAddress(Placemark placemarks) {
  String keyword = 'Malaysia';
  String street = '${placemarks.street}';
  String subLocality = '${placemarks.subLocality}';
  String postalCode = '${placemarks.postalCode}';
  String locality = '${placemarks.locality}';
  String administrativeArea = '${placemarks.administrativeArea}';
  String country = '${placemarks.country}';

  String formattedAddress;

  if (street != keyword && country == keyword) {
    subLocality.isEmpty
        ? formattedAddress =
            '$street, $postalCode $locality, $administrativeArea, $locality $country'
        : formattedAddress =
            '$street, $subLocality, $postalCode $locality, $administrativeArea, $country';
  } else {
    formattedAddress = kInvalidAddress;
  }

  return formattedAddress;
}
