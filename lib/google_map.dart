import 'package:danger_zone_alert/circle_area/components/create_marker.dart';
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
  // Instantiate helper class
  GenerateAddress generateAddress = GenerateAddress();
  DangerArea dangerArea = DangerArea();
  MarkerCreator markerCreator = MarkerCreator();

  late GoogleMapController _googleMapController;

  // LatLng Bounds so user wouldn't hover so much from outside of Malaysia
  final LatLngBounds malaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925),
  );

  static const _kInitialViewPosition = CameraPosition(
    target: LatLng(5.3571666, 100.2886158),
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
    return Scaffold(
      body: SafeArea(
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
              zoomControlsEnabled: false,
              markers: Set.from(markerCreator.markers),
              circles: Set.from(dangerArea.circles),
              onTap: (tapLatLng) async {
                // Get the description of the tapped position
                var address =
                    await generateAddress.getMarkers(latLng: tapLatLng);
                print(tapLatLng);

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.blueAccent,
        child: const Icon(
          Icons.my_location_rounded,
          color: Colors.white,
        ),
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_kInitialViewPosition),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomTabBar(),
    );
  }
}

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: SizedBox(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Right Tab Icon Bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconBar(
                  text: '',
                  icon: Icons.web_rounded,
                  padding: const EdgeInsets.only(left: 24.0),
                  onPressed: () {},
                ),
              ],
            ),
            // Left Tab Icon Bar
            Row(
              children: <Widget>[
                IconBar(
                  text: '',
                  icon: Icons.logout_rounded,
                  padding: const EdgeInsets.only(right: 24.0),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final Function() onPressed;

  const IconBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.padding,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              icon,
              size: 25.0,
              color: Colors.blueAccent,
            ),
            onPressed: onPressed,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
              height: .1,
              color: Colors.blueAccent,
            ),
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
