import 'dart:ui';

import 'package:danger_zone_alert/google_map/util/camera_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaMarker {
  final List<Marker> _markers = [];

  createMarker(latLng, placemark, googleMapController) async {
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
    navigateToLocation(latLng, googleMapController);
  }

  List<Marker> get markers => _markers;
}
