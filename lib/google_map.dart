import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'circle_area/area_rating_box.dart';
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
  GenerateAddress generatePlacemarks = GenerateAddress();
  late dynamic placemark;

  DangerArea radius = DangerArea();

  late GoogleMapController _googleMapController;
  final bool _myLocationEnabled = false;
  final bool _myCompassEnabled = false;
  final bool _mapToolbarEnabled = false;
  final bool _myTrafficEnabled = false;
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

  void boxCallback() {
    setState(() {
      disposeMarker();
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
            myLocationEnabled: _myLocationEnabled,
            compassEnabled: _myCompassEnabled,
            mapToolbarEnabled: _mapToolbarEnabled,
            trafficEnabled: _myTrafficEnabled,
            markers: Set.from(markers),
            circles: Set.from(radius.getCircles),
            onTap: (latLng) async {
              // Get the description of the tapped position
              placemark = await generatePlacemarks.getMarkers(latLng: latLng);
              // print(placemark);
              // print(latLng);

              setState(() {
                _createMarker(latLng: latLng, placemark: placemark);

                showDialog(
                  context: context,
                  builder: (context) => Column(
                    children: [
                      // AreaDescriptionBox(
                      //   radius: radius,
                      //   areaDescription: placemark,
                      //   areaLatLng: latLng,
                      //   boxCallback: boxCallback,
                      // ),
                      AreaRatingBox(
                        radius: radius,
                        areaDescription: placemark,
                        areaLatLng: latLng,
                        boxCallback: boxCallback,
                      ),
                    ],
                  ),
                );
              });
            },
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_kInitialViewPosition),
              ),
              child: const Icon(
                Icons.location_on,
              ),
            ),
          ),
          // displayDialog(),
        ],
      ),
    );
  }

  // Markers code section start here
  List<Marker> markers = [];

  _createMarker({@required latLng, @required placemark}) {
    // Clear the list for markers
    disposeMarker();

    markers.add(Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      infoWindow: InfoWindow(
        title: '$placemark',
        anchor: const Offset(0.5, 0),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    ));

    // Re-center the screen corresponding to the latLng of the marker
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  // Clear list for markers
  void disposeMarker() {
    markers.clear();
  }
}

/*
* TODO 1: Try to display the value of latlng even when the user tapped on the circle_area
* TODO 2: Create a method to check if the latlng is within the circle_area radius : https://stackoverflow.com/questions/22063842/check-if-a-latitude-and-longitude-is-within-a-circle
* TODO 3: If so display the marker within the circle_area with the simple dialog box displaying the address of the latlng
* As long as the user click within the circle_area, the simple dialog box will display with different address corresponding to the latlng but comment and rating data is consider as one within the same circle_area
* TODO: Create an algorithm to reposition the new circle_area so it wouldn't overlap with the existing one
* */
