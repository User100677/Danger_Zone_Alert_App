import 'package:google_maps_flutter/google_maps_flutter.dart';

final LatLngBounds kMalaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925));

const CameraPosition kInitialCameraPosition = CameraPosition(
    target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

// TODO Compile the color code used
