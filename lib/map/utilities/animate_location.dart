import 'package:google_maps_flutter/google_maps_flutter.dart';

animateToLocation(latLng, googleMapController, {double zoom = 19}) async {
  final GoogleMapController controller = await googleMapController.future;

  controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: zoom)));
}
