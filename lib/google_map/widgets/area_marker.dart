import 'package:google_maps_flutter/google_maps_flutter.dart';

class AreaMarker {
  final List<Marker> _markers = [];

  addMarker(latLng) async {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  List<Marker> get markers => _markers;
}
