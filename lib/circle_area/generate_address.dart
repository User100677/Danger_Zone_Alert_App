import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class GenerateAddress {
  Future<String> getAddress({@required latLng}) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'ms_MY');

    return _parseAddress(placeMark[0]);
  }

  // This method format the address into String
  String _parseAddress(Placemark placemarks) {
    String street = '${placemarks.street}';
    String subLocality = '${placemarks.subLocality}';
    String postalCode = '${placemarks.postalCode}';
    String locality = '${placemarks.locality}';
    String administrativeArea = '${placemarks.administrativeArea}';
    String country = '${placemarks.country}';

    String formattedAddress;

    if (street != 'Malaysia' && country == 'Malaysia') {
      subLocality.isEmpty
          ? formattedAddress =
              '$street, $postalCode $locality, $administrativeArea, $locality $country'
          : formattedAddress =
              '$street, $subLocality, $postalCode $locality, $administrativeArea, $country';
    } else {
      formattedAddress = 'Invalid';
    }

    return formattedAddress;
  }
}
