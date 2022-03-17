import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/map/camera_coordinate.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseServiceTest {
  final String? uid;

  final geo = Geoflutterfire();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference areaCollection =
      FirebaseFirestore.instance.collection('areas');

  DatabaseServiceTest({this.uid});

  /* - User - */
  Future updateUserRatedAreasData(LatLng latLng, double rating) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    // Use geoHash as document id
    return await userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(location.hash)
        .set({'rating': rating, 'geopoint': location.geoPoint});
  }

  // This function should be in area_rating_box
  // Return a single snapshot (The clicked circle's data center or null)
  Future<DocumentSnapshot> getUserCurrentRatedAreaData(LatLng latLng) {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    final userRatedAreasCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('ratedAreas');

    return userRatedAreasCollection.doc(location.hash).get();
  }

  // Stream<List<DocumentSnapshot>> getRatedArea(controller, context) async* {
  //   var latLng = await controller.getLatLng(cameraMiddleCoordinate(context));
  //
  //   GeoFirePoint center =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  //
  //   double radius = 50;
  //   String field = 'geoData';
  //
  //   yield* geo
  //       .collection(
  //           collectionRef: userCollection.doc(uid).collection('ratedAreas'))
  //       .within(center: center, radius: radius, field: field);
  // }

  /* Areas */
  Future updateAreasData(
      LatLng latLng, double rating, String color, int totalUsers) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection.doc(location.hash).set({
      'color': color,
      'totalUsers': totalUsers,
      'rating': rating,
      'geoData': location.data
    });
  }

  Stream<List<DocumentSnapshot>> getAreas(controller, context) async* {
    var latLng = await controller.getLatLng(cameraMiddleCoordinate(context));

    GeoFirePoint center =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    double radius = 40;
    String field = 'geoData';

    yield* geo
        .collection(
            collectionRef: FirebaseFirestore.instance.collection('areas'))
        .within(center: center, radius: radius, field: field);
  }
}

// Stream<List<DocumentSnapshot>> userRatedAreaDefault(latLng) {
//   print(latLng);
//
//   GeoFirePoint center =
//       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
//
//   double radius = 1;
//   String field = 'position';
//
//   return geo
//       .collection(
//           collectionRef: userCollection.doc(uid).collection('ratedAreas'))
//       .within(center: center, radius: radius, field: field);
// }

// Stream<List<DocumentSnapshot>> userRatedArea(controller, context) async* {
//   var latLng = await controller.getLatLng(cameraMiddleCoordinate(context));
//
//   print(latLng);
//
//   GeoFirePoint center =
//       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
//
//   double radius = 2;
//   String field = 'position';
//
//   yield* geo
//       .collection(
//           collectionRef: userCollection.doc(uid).collection('ratedAreas'))
//       .within(center: center, radius: radius, field: field);
// }
//
// void updateCircle(List<DocumentSnapshot> documentList, UserModel user) {
//   documentList.forEach((DocumentSnapshot document) {
//     var lat = document.get('position')['geopoint'].latitude;
//     var lon = document.get('position')['geopoint'].longitude;
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
//     // user.ratedAreas.add(RatedArea(latLng: LatLng(lat, lon), rating: 4.2));
//   });
// }
