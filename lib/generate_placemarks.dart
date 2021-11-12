import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

class GeneratePlacemarks {
  Future<String> getPlacemarks({@required latLng}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'ms_MY');
    // print("Placemarks Length: ${placemarks.length}");
    // print(placemarks[0]);
    // print("LatLng: $latLng");

    // print(_parsePlacemarks(placemarks[0]));
    return _parsePlacemarks(placemarks[0]);
  }

  // This method is to format the address into String
  String _parsePlacemarks(Placemark placemarks) {
    String street = '${placemarks.street}';
    String subLocality = '${placemarks.subLocality}';
    String postalCode = '${placemarks.postalCode}';
    String locality = '${placemarks.locality}';
    String administrativeArea = '${placemarks.administrativeArea}';
    String country = '${placemarks.country}';

    String formattedAddress;

    // Ternary Operator
    subLocality.isEmpty
        ? formattedAddress =
            '$street, $postalCode $locality, $administrativeArea, $locality $country'
        : formattedAddress =
            '$street, $subLocality, $postalCode $locality, $administrativeArea, $locality $country';

    return formattedAddress;
  }
}
