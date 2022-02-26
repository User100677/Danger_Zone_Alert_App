import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaMarker {
  final List<Marker> _markers = [];

  createMarker(
      {required latLng,
      required placemark,
      required googleMapController}) async {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: '$placemark',
          anchor: const Offset(0.5, 0),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Re-center the screens corresponding to the latLng of the marker
    final GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  List<Marker> get markers => _markers;
}
