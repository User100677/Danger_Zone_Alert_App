import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:danger_zone_alert/services/DatabaseServiceTest.dart';
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
  final UserModel user;
  final Position? position;

  const FireMapScreen({Key? key, required this.user, this.position})
      : super(key: key);

  @override
  _FireMapScreenController createState() => _FireMapScreenController();

  BuildContext getContext() {
    return _FireMapScreenController().context;
  }
}

class _FireMapScreenController extends State<FireMapScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  final Completer<GoogleMapController> _googleMapController = Completer();
  bool isUserInCircle = false;

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

    markers.clear();
    areaCircles.clear();
    _searchBarController.dispose();
    locationSubscription?.cancel();
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      markers.clear();
    });
  }

  _handleMapTap(tapLatLng) async {
    // Get the description of the tapped position
    var address = await getAddress(tapLatLng);

    // TODO: Database testing
    if (widget.user.ratedAreas.isNotEmpty) {
      print(widget.user.ratedAreas.first.latLng);
    } else {
      print("The current user didn't rate that area before!");
    }

    // TODO: Database testing
    // await DatabaseServiceTest(uid: widget.user.uid)
    //     .updateUserRatedAreasData(tapLatLng, 4.2);
    //
    // await DatabaseServiceTest(uid: widget.user.uid)
    //     .updateAreasData(tapLatLng, 4.2, 'Colors.red', 10);

    if (address != kInvalidAddress) {
      bool isWithinAnyCircle = false;

      updateMarker(tapLatLng);
      animateToLocation(tapLatLng, _googleMapController);

      // Check if tapLatLng is within any circles
      if (areaCircles.isNotEmpty) {
        for (Circle circle in areaCircles) {
          double distance = calculateDistance(circle.center, tapLatLng);

          if (isWithinCircle(distance)) {
            isWithinAnyCircle = true;
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) => AreaRatingBox(
                      areaDescription: address,
                      areaLatLng: circle.center,
                      user: widget.user,
                      boxCallback: boxCallback));
            });

            // TODO: Database
            widget.user.ratedAreas.clear();
            var x = await DatabaseServiceTest(uid: widget.user.uid)
                .getUserCurrentRatedAreaData(circle.center);

            if (x.data() != null) {
              widget.user.ratedAreas.add(RatedArea(
                  latLng: LatLng(
                      x.get('geopoint').latitude, x.get('geopoint').longitude),
                  rating: x.get('rating')));
            }

            break;
          }
        }
      }

      if (!isWithinAnyCircle) {
        isWithinAnyCircle = false;
        setState(() {
          showDialog(
              context: context,
              builder: (context) => AreaDescriptionBox(
                  areaDescription: address,
                  tapLatLng: tapLatLng,
                  user: widget.user,
                  boxCallback: boxCallback));
        });
      }
    }

    // TODO: Database
    // if (circleLatLng != null) {
    //   var x = await DatabaseServiceTest(uid: widget.user.uid)
    //       .getUserCurrentRatedAreaData(circleLatLng);
    //
    //   print(x.get('geopoint').latitude);
    // }
  }

  // Contain the logic of notification alert using user GPS
  void _notificationLogic() {
    if (areaCircles.isNotEmpty) {
      for (Circle circle in areaCircles) {
        double userDistance =
            calculateDistance(circle.center, widget.user.latLng);

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
  _onMapCreated(GoogleMapController controller) async {
    _googleMapController.complete(controller);

    try {
      widget.user.setLatLng(await validateLocation(widget.position));
      widget.user.setAccess = true;
    } catch (e) {
      errorSnackBar(context, e.toString());
      widget.user.setAccess = false;
    }

    // DatabaseServiceTest(uid: widget.user.uid)
    //     .getRatedArea(controller, context)
    //     .listen((List<DocumentSnapshot> documentList) {
    //   widget.user.ratedAreas.clear();
    //
    //   // TODO: For some reason this work but not when put in a method
    //   documentList.forEach((DocumentSnapshot document) {
    //     var lat = document.get('geoData')['geopoint'].latitude;
    //     var lon = document.get('geoData')['geopoint'].longitude;
    //
    //     areaCircles2.add(Circle(
    //       circleId: CircleId(LatLng(lat, lon).toString()),
    //       center: LatLng(lat, lon),
    //       radius: kAreaRadius,
    //       strokeWidth: 0,
    //       fillColor: const Color.fromRGBO(255, 0, 0, .5),
    //       consumeTapEvents: false,
    //     ));
    //
    //     widget.user.ratedAreas
    //         .add(RatedArea(latLng: LatLng(lat, lon), rating: 4.2));
    //   });
    // });

    // Navigate and set stream for user location
    if (widget.user.latLng != null) {
      animateToLocation(widget.user.latLng, _googleMapController);

      GeolocatorService.getCurrentLocation().listen((position) {
        // widget.user.setLatLng(LatLng(position.latitude, position.longitude));
        setState(() {
          widget.user.setLatLng(LatLng(position.latitude, position.longitude));
        });

        _notificationLogic();
      });
    }

    DatabaseServiceTest(uid: widget.user.uid)
        .getAreas(controller, context)
        .listen((List<DocumentSnapshot> documentList) {
      widget.user.ratedAreas.clear();

      // TODO: For some reason this work but not when put in a method
      documentList.forEach((DocumentSnapshot document) {
        if (!mounted) return;

        var lat = document.get('geoData')['geopoint'].latitude;
        var lon = document.get('geoData')['geopoint'].longitude;

        setState(() {
          areaList.add(Area(
              latLng: LatLng(lat, lon),
              rating: 4.2,
              rateCount: 8,
              color: 'Colors.red'));
        });
        // widget.user.ratedAreas
        //     .add(RatedArea(latLng: LatLng(lat, lon), rating: 4.2));
      });
    });

    // TODO: Problem occured when running below databaseservice code
    // TODO: It happen probably because setState is constantly called even
    // TODO: during reload

    // DatabaseService(uid: widget.user.uid).areas.listen((areas) {
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
              onMapCreated: (GoogleMapController controller) =>
                  state._onMapCreated(controller),
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
            buildBottomTabBar(context, state._googleMapController),
            buildSearchBar(context, state._searchBarController),
          ],
        ),
      ),
    );
  }
}
