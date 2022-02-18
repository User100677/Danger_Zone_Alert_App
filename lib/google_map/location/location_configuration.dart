import 'dart:async';

import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/error_snackbar.dart';
import '../google_map.dart';

class LocationConfiguration {
  final GeolocatorService _geolocatorService = GeolocatorService();
  bool _isGPSWithinMY = false;

  // User location validation
  Future<LatLng?> getInitialPosition({required context}) async {
    Position position = await _geolocatorService.determinePosition(context);
    LatLng latLng = LatLng(position.latitude, position.longitude);

    if (kMalaysiaBounds.contains(latLng)) {
      _isGPSWithinMY = true;

      return latLng;
    } else {
      _isGPSWithinMY = false;
      errorSnackBar(context, 'Location outside Malaysia is not supported.');
    }
    return null;
  }

  // Navigate to user location
  navigateToLocation(LatLng latLng, googleMapController) async {
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  GeolocatorService get geolocatorService => _geolocatorService;

  get isGPSWithinMY => _isGPSWithinMY;
}
