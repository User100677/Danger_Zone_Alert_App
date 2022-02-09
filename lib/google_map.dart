import 'dart:async';

import 'package:danger_zone_alert/circle_area/components/area_marker.dart';
import 'package:danger_zone_alert/circle_area/components/bottom_tab_bar.dart';
import 'package:danger_zone_alert/circle_area/geolocator_service.dart';
import 'package:flutter/material.dart';
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
  AreaMarker markerCreator = AreaMarker();
  GeolocatorService geolocatorService = GeolocatorService();

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _googleMapController.complete(controller);
      geolocatorService.getInitialPosition(
          context: context, googleMapController: _googleMapController);
    });
  }

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
              initialCameraPosition: geolocatorService.initialPosition,
              cameraTargetBounds: CameraTargetBounds(kMalaysiaBounds),
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              zoomControlsEnabled: false,
              markers: Set.from(markerCreator.markers),
              circles: Set.from(dangerArea.circles),
              onTap: (tapLatLng) async {
                // Get the description of the tapped position
                var address =
                    await generateAddress.getAddress(latLng: tapLatLng);
                print('Tap latLng: ' + tapLatLng.toString());
                // print('Current user Location: ' +
                //     geolocatorService.currentPosition.toString());

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
                setState(() {
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      geolocatorService.currentPosition));
                });
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
- TODO: Notification when user enter a red circle?


Circle:
* As long as the user click within the circle_area, the simple dialog box will display with different address corresponding to the latlng but comment and rating data is consider as one within the same circle_area
* TODO: Create an algorithm to reposition the new circle_area so it wouldn't overlap with the existing one
* */
