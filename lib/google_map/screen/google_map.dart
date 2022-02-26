import 'dart:async';

import 'package:danger_zone_alert/google_map/components/area_marker.dart';
import 'package:danger_zone_alert/google_map/components/bottom_tab_bar.dart';
import 'package:danger_zone_alert/google_map/components/error_snackbar.dart';
import 'package:danger_zone_alert/google_map/location/location_configuration.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../area.dart';
import '../calculate_distance.dart';
import '../components/area_description_box.dart';
import '../components/area_rating_box.dart';
import '../reverse_geocoding.dart';

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
  Area area = Area();
  AreaMarker areaMarker = AreaMarker();
  ReverseGeocoding reverseGeocoding = ReverseGeocoding();
  LocationConfiguration locationConfiguration = LocationConfiguration();

  final CameraPosition kInitialCameraPosition = const CameraPosition(
      target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      areaMarker.markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    void _onMapCreated(GoogleMapController controller) async {
      _googleMapController.complete(controller);
      // set initial user position
      user?.setLatLng(
          await locationConfiguration.getInitialPosition(context: context));

      // Navigate to user location if its within Malaysia
      if (locationConfiguration.isGPSWithinMY) {
        setState(() {
          locationConfiguration.navigateToLocation(
              user?.latLng, _googleMapController);
        });
        locationConfiguration.geolocatorService
            .getCurrentLocation()
            .listen((position) {
          user?.setLatLng(LatLng(position.latitude, position.longitude));
        });
      }
    }

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
                    await reverseGeocoding.getAddress(latLng: tapLatLng);
                // print('Tap latLng: ' + tapLatLng.toString());
                // print(user?.latLng);

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
                LatLng? userPosition = user?.latLng;

                // Display error notification if userPosition is null else navigate to user position
                if (userPosition == null) {
                  errorSnackBar(context, 'Navigation failed!');
                } else {
                  locationConfiguration.navigateToLocation(
                      userPosition, _googleMapController);
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
* As long as the user click within the google_map, the simple dialog box will display with different address corresponding to the latlng but comment and rating data is consider as one within the same google_map
* TODO: Create an algorithm to reposition the new google_map so it wouldn't overlap with the existing one
* */
