import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // collection reference
  /* It doesn't matter whether the collection exist or not. If it doesn't exist
     then firebase will create the new collection for you. */
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // TODO: Only all area data needs to be extracted all at once. Comment of each
  // only needed when the comment button is clicked
  final CollectionReference areaCollection =
      FirebaseFirestore.instance.collection('areas');

  /* Each user contain a unique id and thus we can differentiate them using that id */
  Future updateUserData(LatLng latLng, double rating) async {
    return await userCollection
        .doc(uid)
        .collection('ratedAreas')
        .doc(latLng.toString())
        .set({
      'rating': rating,
    });
  }

  // What if the user don't have any ratedArea? = No error apparently
  // For testing purposes
  Future getUserData(UserModel user) async {
    await userCollection
        .doc(uid)
        .collection('ratedAreas')
        .get()
        .then((querySnapshot) => {
              user.ratedAreas = _userRatedAreaListFromSnapshot(querySnapshot),
              print("Store in model? "),
              print(user.ratedAreas.first.latLng),
            });
  }

  // Return a list of ratedArea into class RatedArea in user.dart
  List<RatedArea> _userRatedAreaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<String> latLng =
          doc.id.replaceAll('LatLng(', "").replaceAll(')', "").split(', ');

      double latitude = double.parse(latLng[0]);
      double longitude = double.parse(latLng[1]);

      print("Recorded Latitude & Longitude: ");
      print(LatLng(latitude, longitude));

      return RatedArea(
          latLng: LatLng(latitude, longitude), rating: doc['rating']);
    }).toList();
  }

  Stream<List<RatedArea>> get userRatedArea {
    return userCollection.snapshots().map(_userRatedAreaListFromSnapshot);
  }

  // <---------------------- Area -------------------->
  Future updateAreaData(
      LatLng latLng, String color, int rateCount, int rating) async {
    return await areaCollection.doc(latLng.toString()).set({
      'rating': rating,
      'rateCount': rateCount,
      'color': color,
    });
  }

  List<Area> _areaListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<String> latLng =
          doc.id.replaceAll('LatLng(', "").replaceAll(')', "").split(', ');

      double latitude = double.parse(latLng[0]);
      double longitude = double.parse(latLng[1]);

      return Area(
        latLng: LatLng(latitude, longitude),
        rating: doc['rating'] ?? 0.0,
        rateCount: doc['rateCount'] ?? 0,
        color: doc['color'] ?? 'Colors.grey',
      );
    }).toList();
  }

  // Add a comment using as the current user
  Future addCommentData(LatLng latLng, String text, User user) async {
    return await areaCollection
        .doc(latLng.toString())
        .collection('comments')
        .doc(uid)
        .set({
      'likeNDislike': 0,
      'text': text,
      'email': user.email,
    });
  }

  // TODO: How do you know if the user already like that specific comment?
  // TODO: If so how to make sure he/she can only affect it once (Add stuff to userModel)
  Future updateCommentLikeCount(
      LatLng latLng, bool isIncrement, int index) async {
    return await areaCollection
        .doc(latLng.toString())
        .collection('comments')
        .doc(index.toString())
        .update({
      "like": isIncrement ? FieldValue.increment(1) : FieldValue.increment(-1)
    });
  }

  List<Comment> _commentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Comment(
        likeNDislike: doc['likeNDislike'],
        text: doc['text'],
        email: doc['email'],
      );
    }).toList();
  }

  Stream<List<Area>> get areas =>
      areaCollection.snapshots().map(_areaListFromSnapshot);

  Stream<List<Comment>> getComments(LatLng latLng) {
    return areaCollection
        .doc(latLng.toString())
        .collection('comments')
        .snapshots()
        .map(_commentListFromSnapshot);
  }
}
