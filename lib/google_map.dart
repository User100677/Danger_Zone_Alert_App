import 'package:danger_zone_alert/circle_area/create_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'circle_area/area_description_box.dart';
import 'circle_area/area_rating_box.dart';
import 'circle_area/calculate_distance.dart';
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
  // Instantiate helper class
  GenerateAddress generateAddress = GenerateAddress();
  DangerArea dangerArea = DangerArea();
  MarkerCreator markerCreator = MarkerCreator();

  late dynamic placeMark;
  late GoogleMapController _googleMapController;

  // LatLng Bounds so user wouldn't hover so much from outside of Malaysia
  final LatLngBounds malaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925),
  );

  static const _kInitialViewPosition = CameraPosition(
    target: LatLng(3.073838, 101.518349),
    zoom: 18,
  );

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  // Callback method to clear markers
  void boxCallback() {
    setState(() {
      markerCreator.markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) => _googleMapController = controller,
            minMaxZoomPreference: const MinMaxZoomPreference(7, 19),
            cameraTargetBounds: CameraTargetBounds(malaysiaBounds),
            initialCameraPosition: _kInitialViewPosition,
            myLocationEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            trafficEnabled: false,
            markers: Set.from(markerCreator.markers),
            circles: Set.from(dangerArea.circles),
            onTap: (tapLatLng) async {
              // Get the description of the tapped position
              placeMark = await generateAddress.getMarkers(latLng: tapLatLng);
              print(tapLatLng);

              // malaysiaPolygonParser();

              // TODO: Move the logic into another dart file
              setState(() {
                bool isWithinAnyCircle = false;

                markerCreator.createMarker(
                    latLng: tapLatLng,
                    placemark: placeMark,
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
                          areaDescription: placeMark,
                          areaLatLng: tapLatLng,
                          boxCallback: boxCallback,
                        ),
                      );
                      isWithinAnyCircle = true;
                      break;
                    }
                    // (dangerArea.isWithinCircle(distance))
                    //     ? print("Tap is within the radius of " +
                    //         circle.circleId.toString())
                    //     : print("Tap is not within the radius of " +
                    //         circle.circleId.toString());
                  }
                }

                if (!isWithinAnyCircle) {
                  showDialog(
                    context: context,
                    builder: (context) => AreaDescriptionBox(
                      radius: dangerArea,
                      areaDescription: placeMark,
                      areaLatLng: tapLatLng,
                      boxCallback: boxCallback,
                    ),
                  );
                  isWithinAnyCircle = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

/*
* As long as the user click within the circle_area, the simple dialog box will display with different address corresponding to the latlng but comment and rating data is consider as one within the same circle_area
* TODO: Create an algorithm to reposition the new circle_area so it wouldn't overlap with the existing one
* */
