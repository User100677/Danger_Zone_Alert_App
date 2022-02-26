import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final LocationSettings _locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  bool isLoading = false;

  // Get user location with exception handling
  Future<Position> getInitialLocation(context) async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Stream update current user locations
  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings);
  }

  bool getIsLoading() => isLoading;
}
