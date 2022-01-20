import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

class GenerateAddress {
  Future<String> getMarkers({@required latLng}) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'ms_MY');
    // print("Placed Makers Length: ${placeMark.length}");
    // print(placeMark[0]);
    // print("LatLng: $latLng");

    // print(_parseAddress(placeMark[0]));
    return _parseAddress(placeMark[0]);
  }

  // This method is to format the address into String
  String _parseAddress(Placemark placemarks) {
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
