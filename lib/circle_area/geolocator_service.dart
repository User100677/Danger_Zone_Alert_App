import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/error_snackbar.dart';

final LatLngBounds kMalaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925));

class GeolocatorService {
  CameraPosition _currentPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 18);

  final CameraPosition _initialPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

  final LocationSettings _locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  // Indicate whether the user GPS is in Malaysia
  bool _isGPSWithinMY = false;

  // User location validation
  Future<void> getInitialPosition(
      {required context, required googleMapController}) async {
    Position position = await determinePosition(context);
    LatLng latLng = LatLng(position.latitude, position.longitude);

    if (kMalaysiaBounds.contains(latLng)) {
      _isGPSWithinMY = true;

      _navigateToLocation(latLng, googleMapController);
      updatePosition();
    } else {
      _isGPSWithinMY = false;
      errorSnackBar(context, 'Location outside Malaysia is not supported.');
    }
  }

  Future<Position> determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      errorSnackBar(context, 'Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorSnackBar(context, 'Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Navigate to user location
  _navigateToLocation(LatLng latLng, googleMapController) async {
    _currentPosition = CameraPosition(target: latLng, zoom: 18);

    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }

  // Stream update user location
  updatePosition() async {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position position) {
      _currentPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 18);
    });
  }

  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings);
  }

  get currentPosition => _currentPosition;

  get initialPosition => _initialPosition;

  get isGPSWithinMY => _isGPSWithinMY;
}
