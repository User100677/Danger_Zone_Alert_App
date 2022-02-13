import 'dart:async';

import 'package:danger_zone_alert/circle_area/components/area_marker.dart';
import 'package:danger_zone_alert/circle_area/components/bottom_tab_bar.dart';
import 'package:danger_zone_alert/circle_area/components/error_snackbar.dart';
import 'package:danger_zone_alert/circle_area/location/user_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'circle_area/area.dart';
import 'circle_area/calculate_distance.dart';
import 'circle_area/components/area_description_box.dart';
import 'circle_area/components/area_rating_box.dart';
import 'circle_area/generate_address.dart';

final LatLngBounds kMalaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925));

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
  Area area = Area();
  AreaMarker areaMarker = AreaMarker();
  UserLocation userLocation = UserLocation();

  final CameraPosition kInitialCameraPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _googleMapController.complete(controller);
      userLocation.getInitialPosition(
          context: context, googleMapController: _googleMapController);
    });
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      areaMarker.markers.clear();
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
              initialCameraPosition: kInitialCameraPosition,
              cameraTargetBounds: CameraTargetBounds(kMalaysiaBounds),
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              zoomControlsEnabled: false,
              markers: Set.from(areaMarker.markers),
              circles: Set.from(area.circles),
              onTap: (tapLatLng) async {
                // Get the description of the tapped position
                var address =
                    await generateAddress.getAddress(latLng: tapLatLng);
                print('Tap latLng: ' + tapLatLng.toString());
                // print('Current user Location: ' +
                //     geolocatorService.currentPosition.toString());

                if (address != 'Invalid') {
                  setState(
                    () {
                      bool isWithinAnyCircle = false;

                      areaMarker.createMarker(
                          latLng: tapLatLng,
                          placemark: address,
                          googleMapController: _googleMapController);

                      // Check if tapLatLng is within any circles
                      if (area.circles.isNotEmpty) {
                        for (Circle circle in area.circles) {
                          double distance =
                              calculateDistance(circle.center, tapLatLng);

                          if (area.isWithinCircle(distance)) {
                            showDialog(
                              context: context,
                              builder: (context) => AreaRatingBox(
                                area: area,
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
                            area: area,
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
                var userPosition = userLocation.currentPosition;
                final GoogleMapController controller =
                    await _googleMapController.future;

                // popup error notification if userPosition is null else navigate to user position
                if (userPosition == null) {
                  errorSnackBar(context, 'Navigation failed!');
                } else {
                  setState(() => controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                          userLocation.currentPosition)));
                }
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
