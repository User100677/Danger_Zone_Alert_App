import 'dart:async';

import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/google_map/utilities/area_notification.dart';
import 'package:danger_zone_alert/google_map/utilities/location_configuration.dart';
import 'package:danger_zone_alert/google_map/widgets/area_marker.dart';
import 'package:danger_zone_alert/google_map/widgets/bottom_tab_bar.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../area.dart';
import '../calculate_distance.dart';
import '../reverse_geocoding.dart';
import '../widgets/area_description_box.dart';
import '../widgets/area_rating_box.dart';

class GoogleMapScreen extends StatefulWidget {
  static String id = "google_map_screen";
  Position? position;

  GoogleMapScreen({Key? key, this.position}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();

  BuildContext getContext() {
    return _GoogleMapScreenState().context;
  }
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  final Completer<GoogleMapController> _googleMapController = Completer();

  // Instantiate helper class
  Area area = Area();
  AreaMarker areaMarker = AreaMarker();
  ReverseGeocoding reverseGeocoding = ReverseGeocoding();
  LocationConfiguration locationConfiguration = LocationConfiguration();

  @override
  void initState() {
    super.initState();

    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null);

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      areaMarker.markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    bool isUserInCircle = false;

    // Contain the logic of notification alert using user GPS
    void _notificationLogic() {
      if (area.circles.isNotEmpty) {
        for (Circle circle in area.circles) {
          double userDistance = calculateDistance(circle.center, user?.latLng);

          if (area.isWithinCircle(userDistance) && isUserInCircle == false) {
            isUserInCircle = true;
            showOngoingNotification(notifications,
                title: 'You entered a Red Zone',
                body: 'Stay conscious and beware of your surrounding.');
            break;
          }

          if (!area.isWithinCircle(userDistance)) {
            isUserInCircle = false;
          }
        }
      }
    }

    // Contain the logic of user GPS
    void _locationLogic() {
      if (locationConfiguration.isGPSWithinMY) {
        setState(() {
          locationConfiguration.navigateToLocation(
              user?.latLng, _googleMapController);
        });
        locationConfiguration.geolocatorService
            .getCurrentLocation()
            .listen((position) {
          user?.setLatLng(LatLng(position.latitude, position.longitude));

          _notificationLogic();
        });
      }
    }

    // Called when the google map is created
    void _onMapCreated(GoogleMapController controller) async {
      _googleMapController.complete(controller);

      // Set initial user position
      user?.setLatLng(await locationConfiguration
          .validateLocation(context: context, position: widget.position)
          .catchError((e) => errorSnackBar(context, e)));

      _locationLogic();
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
