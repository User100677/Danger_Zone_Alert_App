import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerCreator {
  final List<Marker> _markers = [];

  createMarker(
      {required latLng, required placemark, required googleMapController}) {
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

    // Re-center the screen corresponding to the latLng of the marker
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  List<Marker> get markers => _markers;
}
