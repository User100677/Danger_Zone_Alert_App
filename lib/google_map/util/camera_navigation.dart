import 'package:google_maps_flutter/google_maps_flutter.dart';

navigateToLocation(LatLng latLng, googleMapController) async {
  final GoogleMapController controller = await googleMapController.future;
  controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 18)));
}
