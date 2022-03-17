import 'dart:async';

import 'package:danger_zone_alert/blocs/application_bloc.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/util/animate_location.dart';
import 'package:danger_zone_alert/map/util/area_notification.dart';
import 'package:danger_zone_alert/map/util/calculate_distance.dart';
import 'package:danger_zone_alert/map/util/location_validation.dart';
import 'package:danger_zone_alert/map/util/reverse_geocoding.dart';
import 'package:danger_zone_alert/map/widgets/area_description_box.dart';
import 'package:danger_zone_alert/map/widgets/area_marker.dart';
import 'package:danger_zone_alert/map/widgets/area_rating_box.dart';
import 'package:danger_zone_alert/map/widgets/bottom_tab_bar.dart';
import 'package:danger_zone_alert/map/widgets/search_bar.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class FireMapScreen extends StatefulWidget {
  static String id = "fire_map_screen";
  final Position? position;

  const FireMapScreen({Key? key, this.position}) : super(key: key);

  @override
  _FireMapScreenController createState() => _FireMapScreenController();

  BuildContext getContext() {
    return _FireMapScreenController().context;
  }
}

class _FireMapScreenController extends State<FireMapScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  final Completer<GoogleMapController> _googleMapController = Completer();

  // AreaCircle areaCircle = AreaCircle();
  AreaMarker areaMarker = AreaMarker();
  bool isUserInCircle = false;
  // List<Area> areas = [];

  StreamSubscription? locationSubscription;
  final _searchBarController = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();

    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null);

    // initialize local notifications
    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));

    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

    //Listen for selected Location
    locationSubscription =
        applicationBloc.selectedLocation?.stream.listen((place) {
      if (place != null) {
        _searchBarController.query = place.name;
        animateToLocation(place.geometry.location.latLng, _googleMapController);
        _searchBarController.close();
      } else {
        _searchBarController.clear();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    areaCircles.clear();
    _searchBarController.dispose();
    locationSubscription?.cancel();
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      areaMarker.markers.clear();
    });
  }

  _handleMapTap(tapLatLng, UserModel user) async {
    // Get the description of the tapped position
    var address = await getAddress(tapLatLng);

    if (address != kInvalidAddress) {
      setState(
        () {
          bool isWithinAnyCircle = false;

          areaMarker.addMarker(tapLatLng);
          animateToLocation(tapLatLng, _googleMapController);

          // TODO: Database testing
          DatabaseService(uid: user.uid).getUserData(user);
          print("User num of rated area: " + user.ratedAreas.length.toString());

          // Check if tapLatLng is within any circles
          if (areaCircles.isNotEmpty) {
            for (Circle circle in areaCircles) {
              double distance = calculateDistance(circle.center, tapLatLng);

              if (isWithinCircle(distance)) {
                showDialog(
                    context: context,
                    builder: (context) => AreaRatingBox(
                        areaDescription: address,
                        areaLatLng: circle.center,
                        user: user,
                        boxCallback: boxCallback));
                isWithinAnyCircle = true;
                break;
              }
            }
          }

          if (!isWithinAnyCircle) {
            showDialog(
                context: context,
                builder: (context) => AreaDescriptionBox(
                    areaDescription: address,
                    areaLatLng: tapLatLng,
                    user: user,
                    boxCallback: boxCallback));
            isWithinAnyCircle = false;
          }
        },
      );
    }
  }

  // Contain the logic of notification alert using user GPS
  void _notificationLogic(UserModel user) {
    if (areaCircles.isNotEmpty) {
      for (Circle circle in areaCircles) {
        double userDistance = calculateDistance(circle.center, user.latLng);

        if (isWithinCircle(userDistance) && isUserInCircle == false) {
          isUserInCircle = true;
          showOngoingNotification(notifications,
              title: 'You entered a Red Zone', body: 'Stay cautious!');
          break;
        }

        !isWithinCircle(userDistance) ? isUserInCircle = false : null;
      }
    }
  }

  // Called when the google map is created
  _onMapCreated(GoogleMapController controller, UserModel user) async {
    _googleMapController.complete(controller);

    try {
      user.setLatLng(await validateLocation(widget.position));
      user.setAccess = true;
    } catch (e) {
      errorSnackBar(context, e.toString());
      user.setAccess = false;
    }

    // TODO: Problem occcured when running below databaseservice code
    // TODO: It happen probably because setState is constantly called even
    // TODO: during reload
    // DatabaseService(uid: user.uid).areas.listen((areas) {
    //   setState(() {
    //     areaList = areas;
    //   });
    // });

    // print("Logic areas' length " + areas.length.toString());

    // DatabaseService(uid: user.uid).userRatedArea.listen((userRatedAreas) {
    //   setState(() {
    //     user.ratedAreas = userRatedAreas;
    //   });
    // });
    //
    // print(
    //     "Logic user ratedAreas' length: " + user.ratedAreas.length.toString());

    // Navigate and set stream for user location
    if (user.latLng != null) {
      animateToLocation(user.latLng, _googleMapController);

      GeolocatorService.getCurrentLocation().listen((position) {
        user.setLatLng(LatLng(position.latitude, position.longitude));

        _notificationLogic(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) => _FireMapScreenView(this);
}

// GoogleMapScreenView
class _FireMapScreenView
    extends WidgetView<FireMapScreen, _FireMapScreenController> {
  const _FireMapScreenView(_FireMapScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // final user = context.watch<UserModel?>();
    // TODO: Database user ratedAreas always 0 the first click
    // This is 0 because the following code doesn't work and the working one
    // is the one on the tap google map
    // Solution to try: Notify listener, pass user in google map instead
    user?.ratedAreas = Provider.of<List<RatedArea>>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  state._onMapCreated(controller, user!),
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
              markers: Set.from(state.areaMarker.markers),
              // circles: Set.from(state.areaCircle.circles),
              circles: Set.from(areaCircles),
              onTap: (tapLatLng) => state._handleMapTap(tapLatLng, user!),
            ),
            buildBottomTabBar(context, state._googleMapController),
            buildFloatingSearchBar(
                context, state._searchBarController, state.areaMarker),
          ],
        ),
      ),
    );
  }
}
