import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/map/camera_coordinate.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final String? uid;

  final geo = Geoflutterfire();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference areaCollection =
      FirebaseFirestore.instance.collection('areas');

  DatabaseService({this.uid});

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

  /* Areas */
  // Might need to split into multiple function for individual component's update or even an initialAreasData()
  Future updateAreasData(
      LatLng latLng, double rating, int color, int totalUsers) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection.doc(location.hash).set({
      'color': color,
      'totalUsers': totalUsers,
      'rating': rating,
      'geoData': location.data
    });
  }

  Stream<List<DocumentSnapshot>> getAreasData(
      googleMapController, context) async* {
    final GoogleMapController controller = await googleMapController.future;

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

  /* Areas Comment */

  // TODO: Need to store user's like & dislike (Update) to make sure 1 can't increase the like or dislike count more than once
  // Solution: Get the unique id of the comment and store it in user/ratedAreas/comments
  // so we can check when the user re-like. Get it when the user tap on the like or dislike
  Future postAreasCommentData(latLng, String content, String email) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection.doc(location.hash).collection('comments').add({
      'like': 0,
      'dislike': 0,
      'content': content,
      'email': email,
      // 'time': time,
    });
  }

  List<Comment> _commentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Comment(
        like: doc['like'],
        dislike: doc['dislike'],
        content: doc['email'],
        email: doc['email'],
      );
    }).toList();
  }

  Stream<List<Comment>> getComments(LatLng latLng) {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return areaCollection
        .doc(location.hash)
        .collection('comments')
        .snapshots()
        .map(_commentListFromSnapshot);
  }

  // Edge Case: the user can re-tap on the like button to remove it &
  // pressing dislike remove the like
  Future updateLikeCommentData(
      LatLng latLng, String documentID, bool isLiked, bool isDisliked) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    if (!isLiked && !isDisliked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'like': FieldValue.increment(1),
      });
    }

    if (isLiked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'like': FieldValue.increment(-1),
      });
    }

    if (isDisliked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'like': FieldValue.increment(1),
        'dislike': FieldValue.increment(-1),
      });
    }
  }

  Future updateDislikeCommentData(
      LatLng latLng, String documentID, bool isLiked, bool isDisliked) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    if (!isLiked && !isDisliked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'dislike': FieldValue.increment(1),
      });
    }

    if (isLiked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'dislike': FieldValue.increment(1),
        'like': FieldValue.increment(-1),
      });
    }

    if (isDisliked) {
      return await areaCollection
          .doc(location.hash)
          .collection('comments')
          .doc(documentID)
          .set({
        'dislike': FieldValue.increment(-1),
      });
    }
  }

  // TODO: Get AreaComment (Stream)
  // TODO: Get userCommentLike/Dislike (Stream)
  // TODO: Update/set userCommentLike/Dislike
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
