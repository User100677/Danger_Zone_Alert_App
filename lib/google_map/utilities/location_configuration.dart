import 'dart:async';

import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationConfiguration {
  final GeolocatorService _geolocatorService = GeolocatorService();
  bool _isGPSWithinMY = false;

  // Check if user location is within Malaysia
  Future validateLocation({required context, required position}) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);

    kMalaysiaBounds.contains(latLng)
        ? _isGPSWithinMY = true
        : _isGPSWithinMY = false;

    return _isGPSWithinMY
        ? latLng
        : Future.error('Location outside Malaysia is not supported');
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
