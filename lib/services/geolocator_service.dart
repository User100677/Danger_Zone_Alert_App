import 'package:danger_zone_alert/circle_area/components/error_snackbar.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final LocationSettings _locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  // get user location with exception handling
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

  // Stream update current user location
  Stream<Position> getCurrentLocation() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings);
  }
}
