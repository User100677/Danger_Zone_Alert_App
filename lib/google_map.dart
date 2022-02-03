import 'dart:async';

import 'package:danger_zone_alert/circle_area/components/bottom_tab_bar.dart';
import 'package:danger_zone_alert/circle_area/components/create_marker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'circle_area/calculate_distance.dart';
import 'circle_area/components/area_description_box.dart';
import 'circle_area/components/area_rating_box.dart';
import 'circle_area/danger_area.dart';
import 'circle_area/generate_address.dart';

class GoogleMapScreen extends StatefulWidget {
  static String id = "google_map_screen";

  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();

  BuildContext getContext() {
    return _GoogleMapScreenState().context;
  }
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();

  // Instantiate helper class
  GenerateAddress generateAddress = GenerateAddress();
  DangerArea dangerArea = DangerArea();
  MarkerCreator markerCreator = MarkerCreator();

  // Constant value
  final LatLngBounds _kMalaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925),
  );

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _googleMapController.complete(controller);
    });
    locatePosition();
  }

  CameraPosition _currentPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 18);

  final _initialPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

  /* ---------------------------------------------------------------- */
  // Determine current user location and location permission handling
  Future<Position> _determinePosition() async {
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
      await Geolocator.openLocationSettings();
      errorSnackBar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Error snackBar when permission is denied
  void errorSnackBar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(milliseconds: 3500),
    ));
  }

  Future<void> locatePosition() async {
    Position position = await _determinePosition();

    LatLng latLng = LatLng(position.latitude, position.longitude);
    _currentPosition = CameraPosition(target: latLng, zoom: 18);

    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }
  /* ---------------------------------------------------------------- */

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      markerCreator.markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              minMaxZoomPreference: const MinMaxZoomPreference(7, 19),
              initialCameraPosition: _initialPosition,
              cameraTargetBounds: CameraTargetBounds(_kMalaysiaBounds),
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              compassEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              zoomControlsEnabled: false,
              markers: Set.from(markerCreator.markers),
              circles: Set.from(dangerArea.circles),
              onTap: (tapLatLng) async {
                // Get the description of the tapped position
                var address =
                    await generateAddress.getMarkers(latLng: tapLatLng);
                print(tapLatLng);
                print(_currentPosition);

                // TODO: Move the logic into another dart file
                if (address != 'Invalid') {
                  setState(
                    () {
                      bool isWithinAnyCircle = false;

                      markerCreator.createMarker(
                          latLng: tapLatLng,
                          placemark: address,
                          googleMapController: _googleMapController);

                      // Check if tapLatLng is within any circles
                      if (dangerArea.circles.isNotEmpty) {
                        for (Circle circle in dangerArea.circles) {
                          double distance =
                              calculateDistance(circle.center, tapLatLng);

                          if (dangerArea.isWithinCircle(distance)) {
                            showDialog(
                              context: context,
                              builder: (context) => AreaRatingBox(
                                radius: dangerArea,
                                areaDescription: address,
                                areaLatLng: tapLatLng,
                                boxCallback: boxCallback,
                              ),
                            );
                            isWithinAnyCircle = true;
                            break;
                          }
                        }
                      }

                      if (!isWithinAnyCircle) {
                        showDialog(
                          context: context,
                          builder: (context) => AreaDescriptionBox(
                            radius: dangerArea,
                            areaDescription: address,
                            areaLatLng: tapLatLng,
                            boxCallback: boxCallback,
                          ),
                        );
                        isWithinAnyCircle = false;
                      }
                    },
                  );
                }
              },
            ),
            BottomTabBar(
              onPressed: () async {
                final GoogleMapController controller =
                    await _googleMapController.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(_currentPosition));
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
GPS:
- TODO: Add user location icon
- TODO: Stream update user location
- TODO: Notification when user enter a circle

Exception:
- TODO: What if the user's location is not in Malaysia?


Circle:
* As long as the user click within the circle_area, the simple dialog box will display with different address corresponding to the latlng but comment and rating data is consider as one within the same circle_area
* TODO: Create an algorithm to reposition the new circle_area so it wouldn't overlap with the existing one
* */
