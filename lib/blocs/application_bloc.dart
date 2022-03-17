import 'dart:async';

import 'package:danger_zone_alert/models/place_detail.dart';
import 'package:danger_zone_alert/models/place_search.dart';
import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/services/places_service.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationBloc with ChangeNotifier {
  StreamController<PlaceDetail?>? selectedLocation =
      StreamController<PlaceDetail>.broadcast();
  List<PlaceSearch> searchResults = [];
  PlaceDetail? selectedLocationStatic;

  late final dynamic _context;
  dynamic _position;

  ApplicationBloc(this._context) {
    loadPosition(_context);
  }

  Future<void> loadPosition(context) async {
    try {
      position = await GeolocatorService.getInitialLocation(context);
    } catch (e) {
      errorSnackBar(context, e.toString());
      position = e.toString();
    }
  }

  searchPlaces(String searchTerm) async {
    searchResults = await PlacesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var location = await PlacesService.getPlace(placeId);
    selectedLocation?.add(location);
    selectedLocationStatic = location;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation!.add(null);
    selectedLocationStatic = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation?.close();
    super.dispose();
  }

  get position => _position;

  set position(position) {
    _position = position;
    notifyListeners();
  }

  // TODO area circle
  // final List<Circle> _areas = [];
  //
  // void addCircle(LatLng tappedPoint, Color color) {
  //   _areas.add(
  //     Circle(
  //       // Id is unique for each circle in the _circles and the the index is basically the index. Ex: 0, 1, 2 ...
  //       // circleId: CircleId((_areas.length).toString()),
  //       circleId: CircleId((tappedPoint).toString()),
  //       center: tappedPoint,
  //       radius: kAreaRadius,
  //       strokeWidth: 0,
  //       // fillColor: const Color.fromRGBO(255, 0, 0, .5),
  //       fillColor: color,
  //       consumeTapEvents: false,
  //     ),
  //   );
  //   notifyListeners();
  // }
  //
  // List<Circle> get areas => _areas;
}
