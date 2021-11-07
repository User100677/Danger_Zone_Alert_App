import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './radius.dart';

class GoogleMapScreen extends StatefulWidget {


  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  Radius radius = new Radius();


  late GoogleMapController _googleMapController;

  static const _initialViewPosition = CameraPosition(
    target: LatLng(3.1390, 101.6869),
    zoom: 15,
  );




  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: _initialViewPosition,
          onMapCreated:(controller) =>_googleMapController = controller,
          minMaxZoomPreference: const MinMaxZoomPreference(1, 15),
          zoomControlsEnabled: false,
          circles:   Set.from(radius.getCircles),
          onTap:  radius.handleTap,
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.black,
            onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialViewPosition),
            ),
            child: Icon(Icons.location_on),
          ),
        ),
      ],
    );
  }
}
