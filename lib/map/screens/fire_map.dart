import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/screens/address_activity_box.dart';
import 'package:danger_zone_alert/map/screens/address_box.dart';
import 'package:danger_zone_alert/map/util/animate_location.dart';
import 'package:danger_zone_alert/map/util/application_bloc.dart';
import 'package:danger_zone_alert/map/util/area_notification.dart';
import 'package:danger_zone_alert/map/util/calculate_distance.dart';
import 'package:danger_zone_alert/map/util/location_validation.dart';
import 'package:danger_zone_alert/map/util/reverse_geocoding.dart';
import 'package:danger_zone_alert/map/util/update_markers.dart';
import 'package:danger_zone_alert/map/widgets/search_bar.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/shared/alert_dialog_box.dart';
import 'package:danger_zone_alert/shared/error_snackbar.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FireMapScreen extends StatefulWidget {
  final UserModel user;
  final Position? userPosition;

  const FireMapScreen({Key? key, required this.user, this.userPosition})
      : super(key: key);

  @override
  _FireMapScreenController createState() => _FireMapScreenController();

  BuildContext getContext() {
    return _FireMapScreenController().context;
  }
}

class _FireMapScreenController extends State<FireMapScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  bool isUserInCircle = false;

  StreamSubscription? locationSubscription;
  final _searchBarController = FloatingSearchBarController();

  // Called when the google map is created
  _onMapCreated(GoogleMapController controller) async {
    _googleMapController.complete(controller);

    try {
      widget.user.setLatLng(await validateLocation(widget.userPosition));
      widget.user.setAccess = true;
    } catch (e) {
      errorSnackBar(context, e.toString());
      widget.user.setAccess = false;
    }

    _initializeNotificationsSettings();
    _initializeUserLocation();
    _initializeAreaList();
    _initializeLocationSubscription();
  }

  // Set up android & ios notification
  _initializeNotificationsSettings() {
    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) => null);

    // initialize local notifications
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));
  }

  // Navigate and set stream for user location
  _initializeUserLocation() {
    if (widget.user.latLng != null) {
      animateToLocation(widget.user.latLng, _googleMapController);

      GeolocatorService.getCurrentLocation().listen((position) {
        if (mounted) {
          setState(() {
            widget.user
                .setLatLng(LatLng(position.latitude, position.longitude));
          });
        }
        _initializeNotificationLogic();
      });
    }
  }

  // local_notification logic
  _initializeNotificationLogic() {
    if (areaCircles.isNotEmpty) {
      for (Circle circle in areaCircles) {
        double userDistance =
            calculateDistance(circle.center, widget.user.latLng);

        if (isWithinCircle(userDistance) && isUserInCircle == false) {
          isUserInCircle = true;
          showOngoingNotification(flutterLocalNotificationsPlugin,
              title: 'Stay vigilant', body: 'You have entered a red area.');
          break;
        }

        !isWithinCircle(userDistance) ? isUserInCircle = false : null;
      }
    }
  }

  // Assign the database value into an areaList for display purposes
  _initializeAreaList() {
    DatabaseService(uid: widget.user.uid)
        .getAreasData(_googleMapController, context)
        .listen((List<DocumentSnapshot> documentList) {
      if (documentList.isNotEmpty && mounted) {
        widget.user.ratedAreas.clear();
        areaCircles.clear();
        areaList.clear();
        for (DocumentSnapshot document in documentList) {
          LatLng latLng = LatLng(document.get('geoData')['geopoint'].latitude,
              document.get('geoData')['geopoint'].longitude);
          double rating = document.get('rating');
          var totalUsers = document.get('totalUsers');
          int color = document.get('color');

          setState(() {
            areaList.add(Area(
                latLng: latLng,
                rating: rating,
                totalUsers: totalUsers,
                color: Color(color).withOpacity(0.8)));
          });
        }
      }
    });
  }

  // listen for searched location
  _initializeLocationSubscription() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);

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

  _handleMapTap(tapLatLng) async {
    // Get the description of the tapped position
    var address = await getAddress(tapLatLng);

    if (address != kInvalidAddress) {
      bool isWithinAnyCircle = false;

      updateMarkers(tapLatLng);
      animateToLocation(tapLatLng, _googleMapController);

      // Check if tapLatLng is within any circles
      if (areaCircles.isNotEmpty) {
        for (Circle circle in areaCircles) {
          double distance = calculateDistance(circle.center, tapLatLng);

          if (isWithinCircle(distance)) {
            isWithinAnyCircle = true;
            Area area = areaList[areaCircles.indexOf(circle)];
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) => AddressActivityBox(
                      area: area,
                      description: address,
                      user: widget.user,
                      boxCallback: boxCallback));
            });

            _handleUserRatedArea(circle);
            break;
          }
        }
      }

      if (!isWithinAnyCircle) {
        isWithinAnyCircle = false;
        setState(() {
          showDialog(
              context: context,
              builder: (context) => AddressBox(
                  description: address,
                  latLng: tapLatLng,
                  user: widget.user,
                  boxCallback: boxCallback));
        });
      }
    }
  }

  _handleUserRatedArea(circle) async {
    widget.user.ratedAreas.clear();

    DocumentSnapshot docSnapshot = await DatabaseService(uid: widget.user.uid)
        .getUserRatingData(circle.center);

    if (docSnapshot.exists) {
      widget.user.ratedAreas.add(RatedArea(
          latLng: LatLng(docSnapshot.get('geopoint').latitude,
              docSnapshot.get('geopoint').longitude),
          rating: docSnapshot.get('rating')));
    }
  }

  _handleInfoButtonPressed() {
    showAlertDialogBox(
        AlertType.info,
        'Map Info',
        '1. User can only rate & comment an area that is 1.0km within the user.\n\n'
            '2. An area will be highlighted as gray if the People rated threshold does not exceed 9.\n\n '
            '3. Rating between 0 ~ 3 is green, 3 ~ 3.5 is yellow, 3.5 ~ 4.0 is orange 4.0 ~ 5.0 is red',
        '',
        context);
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      markers.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelNotification();
    markers.clear();
    areaList.clear();
    areaCircles.clear();
    _searchBarController.dispose();
    locationSubscription?.cancel();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                state._onMapCreated(controller);
              },
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
              markers: Set.from(markers),
              circles: Set.from(areaCircles),
              onTap: (tapLatLng) => state._handleMapTap(tapLatLng),
            ),
            // Search Bar
            buildSearchBar(context, state._searchBarController),
            // Info button on the top right of the screen
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 72.0, horizontal: 12.0),
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent, shape: BoxShape.circle),
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.help,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () => state._handleInfoButtonPressed(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.center_focus_strong_rounded),
          onPressed: () => animateToLocation(
              widget.user.latLng, state._googleMapController)),
    );
  }
}
