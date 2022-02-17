import 'dart:async';

import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/error_snackbar.dart';
import '../google_map.dart';

class UserLocation {
  final GeolocatorService _geolocatorService = GeolocatorService();

  CameraPosition? _currentPosition;
  bool _isGPSWithinMY = false;

  // User location validation
  Future getInitialPosition(
      {required context, required googleMapController}) async {
    Position position = await _geolocatorService.determinePosition(context);
    LatLng latLng = LatLng(position.latitude, position.longitude);

    if (kMalaysiaBounds.contains(latLng)) {
      _isGPSWithinMY = true;

      _navigateToLocation(latLng, googleMapController);
      _updatePosition();
    } else {
      _isGPSWithinMY = false;
      errorSnackBar(context, 'Location outside Malaysia is not supported.');
    }
  }

  // Navigate to user location
  _navigateToLocation(LatLng latLng, googleMapController) async {
    _currentPosition = CameraPosition(target: latLng, zoom: 18);

    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition!));
  }

  _updatePosition() async {
    _geolocatorService.getCurrentLocation().listen((Position position) {
      _currentPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 18);
    });
  }

  get currentPosition => _currentPosition;

  get isGPSWithinMY => _isGPSWithinMY;
}
