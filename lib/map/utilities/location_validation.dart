import 'dart:async';

import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future validateLocation(position) async {
  bool _isGPSWithinMY;
  LatLng latLng = LatLng(position.latitude, position.longitude);

  kMalaysiaBounds.contains(latLng)
      ? _isGPSWithinMY = true
      : _isGPSWithinMY = false;

  return _isGPSWithinMY
      ? latLng
      : Future.error('Location outside Malaysia is not supported');
}
