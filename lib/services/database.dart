import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/map/util/camera_coordinate.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
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

  /* <------------------ User ------------------> */
  Future updateUserRatingData(LatLng latLng, double rating) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(location.hash)
        .set({'rating': rating, 'geopoint': location.geoPoint});
  }

  // This function should be in area_rating_box
  // Return a single snapshot (The clicked circle's data center or null)
  Future<DocumentSnapshot> getUserRatingData(LatLng latLng) {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(location.hash)
        .get();
  }

  /* <------------------ User Comment ------------------> */
  // Future updateUserLikedData(
  //     latLng, String commentID, bool isLiked, bool isDisliked) async {
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  //
  //   return await userCollection
  //       .doc(uid)
  //       .collection('ratedAreas')
  //       .doc(location.hash)
  //       .collection('comments')
  //       .doc(commentID)
  //       .set({'liked': !isLiked, 'disliked': false});
  // }
  //
  // Future updateUserDislikedData(
  //     latLng, String commentID, bool isLiked, bool isDisliked) async {
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  //
  //   return await userCollection
  //       .doc(uid)
  //       .collection('ratedAreas')
  //       .doc(location.hash)
  //       .collection('comments')
  //       .doc(commentID)
  //       .set({'liked': false, 'disliked': !isDisliked});
  // }

  List<CommentedArea> _userCommentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CommentedArea(
          id: doc.id, isLiked: doc['liked'], isDisliked: doc['disliked']);
    }).toList();
  }

  Stream<List<CommentedArea>> getUserCommentsData(LatLng latLng) {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(location.hash)
        .collection('comments')
        .snapshots()
        .map(_userCommentListFromSnapshot);
  }

  Future updateUserLikedDisLikedData(
      latLng, String commentID, bool liked, bool disliked) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(location.hash)
        .collection('comments')
        .doc(commentID)
        .set({'liked': liked, 'disliked': disliked});
  }

  Future updateAreaLikesData(
      LatLng latLng, String documentID, bool isIncrement) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection
        .doc(location.hash)
        .collection('comments')
        .doc(documentID)
        .update({
      'likes': isIncrement ? FieldValue.increment(1) : FieldValue.increment(-1)
    });
  }

  Future updateAreaDisLikesData(
      LatLng latLng, String documentID, bool isIncrement) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection
        .doc(location.hash)
        .collection('comments')
        .doc(documentID)
        .update({
      'dislikes':
          isIncrement ? FieldValue.increment(1) : FieldValue.increment(-1)
    });
  }

  /* <------------------ Areas ------------------> */
  // Might need to split into multiple function for individual component's update or even an initialAreasData()
  Future updateAreaData(
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

  /* <------------------ Areas Comment------------------> */
  Future postAreaCommentData(latLng, String content, String? email) async {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return await areaCollection.doc(location.hash).collection('comments').add({
      'likes': 0,
      'dislikes': 0,
      'content': content,
      'email': email ?? 'example@email.com',
      // 'time': time,
    });
  }

  List<Comment> _commentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Comment(
        likes: doc['likes'],
        dislikes: doc['dislikes'],
        content: doc['content'],
        email: doc['email'],
        id: doc.id,
      );
    }).toList();
  }

  Stream<List<Comment>> getAreaComments(LatLng latLng) {
    GeoFirePoint location =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

    return areaCollection
        .doc(location.hash)
        .collection('comments')
        .snapshots()
        .map(_commentListFromSnapshot);
  }

  // Future updateAreaLikesData(
  //     LatLng latLng, String documentID, bool isLiked, bool isDisliked) async {
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  //
  //   if (!isLiked && !isDisliked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({'likes': FieldValue.increment(1)});
  //   }
  //
  //   if (isLiked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({'likes': FieldValue.increment(-1)});
  //   }
  //
  //   if (isDisliked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({
  //       'likes': FieldValue.increment(1),
  //       'dislikes': FieldValue.increment(-1),
  //     });
  //   }
  // }
  //
  // Future updateAreaDislikesData(
  //     LatLng latLng, String documentID, bool isLiked, bool isDisliked) async {
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  //
  //   if (!isLiked && !isDisliked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({'dislikes': FieldValue.increment(1)});
  //   }
  //
  //   if (isLiked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({
  //       'likes': FieldValue.increment(-1),
  //       'dislikes': FieldValue.increment(1),
  //     });
  //   }
  //
  //   if (isDisliked) {
  //     return await areaCollection
  //         .doc(location.hash)
  //         .collection('comments')
  //         .doc(documentID)
  //         .update({'dislikes': FieldValue.increment(-1)});
  //   }
  // }
}
