import 'dart:async';

import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/google_map/area.dart';
import 'package:danger_zone_alert/google_map/calculate_distance.dart';
import 'package:danger_zone_alert/google_map/location_validation.dart';
import 'package:danger_zone_alert/google_map/reverse_geocoding.dart';
import 'package:danger_zone_alert/google_map/util/area_notification.dart';
import 'package:danger_zone_alert/google_map/util/camera_navigation.dart';
import 'package:danger_zone_alert/google_map/widgets/area_description_box.dart';
import 'package:danger_zone_alert/google_map/widgets/area_marker.dart';
import 'package:danger_zone_alert/google_map/widgets/area_rating_box.dart';
import 'package:danger_zone_alert/google_map/widgets/bottom_tab_bar.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  static String id = "google_map_screen";
  final Position? position;

  const GoogleMapScreen({Key? key, this.position}) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null);

    // initialize local notifications
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

    // Main widget
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildGoogleMap(context, user),
            BottomTabBar(
              googleMapController: _googleMapController,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoogleMap(BuildContext context, user) {
    bool isUserInCircle = false;

    // Contain the logic of notification alert using user GPS
    void _notificationLogic() {
      if (area.circles.isNotEmpty) {
        for (Circle circle in area.circles) {
          double userDistance = calculateDistance(circle.center, user?.latLng);

          if (area.isWithinCircle(userDistance) && isUserInCircle == false) {
            isUserInCircle = true;
            showOngoingNotification(notifications,
                title: 'You entered a Red Zone', body: 'Stay cautious!');
            break;
          }

          !area.isWithinCircle(userDistance) ? isUserInCircle = false : null;
        }
      }
    }

    // Called when the google map is created
    void _onMapCreated(GoogleMapController controller) async {
      _googleMapController.complete(controller);

      // Set initial user position
      user?.setLatLng(
          await validateLocation(context: context, position: widget.position)
              .catchError((e) => errorSnackBar(context, e)));

      // Navigate and set stream for user location
      if (user?.latLng != null) {
        navigateToLocation(user?.latLng, _googleMapController);

        GeolocatorService.getCurrentLocation().listen((position) {
          user?.setLatLng(LatLng(position.latitude, position.longitude));

          _notificationLogic();
        });
      }
    }

    return GoogleMap(
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
        var address = await getAddress(latLng: tapLatLng);

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
                  double distance = calculateDistance(circle.center, tapLatLng);

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
    );
  }

  // Floating search bar
  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
