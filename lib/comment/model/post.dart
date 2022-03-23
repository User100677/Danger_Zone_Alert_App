import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  LatLng latLng;
  UserModel user;
  bool userLiked = false;
  bool userDisLiked = false;
  Comment comment;

  late String id;
  late int likes;
  late int dislikes;
  late String email;
  late String content;

  Post(this.user, this.latLng, this.comment) {
    id = comment.id;
    likes = comment.likes;
    dislikes = comment.dislikes;
    email = comment.email;
    content = comment.content;
  }

  void likePost() {
    userLiked = !userLiked;
    DatabaseService(uid: user.uid)
        .updateUserLikedDisLikedData(latLng, id, userLiked, userDisLiked);
    if (userLiked) {
      DatabaseService(uid: user.uid).updateAreaLikesData(latLng, id, true);
    } else {
      DatabaseService(uid: user.uid).updateAreaLikesData(latLng, id, false);
    }

    if (userDisLiked) {
      userDisLiked = !userDisLiked;
      DatabaseService(uid: user.uid)
          .updateUserLikedDisLikedData(latLng, id, userLiked, userDisLiked);
      DatabaseService(uid: user.uid).updateAreaDisLikesData(latLng, id, false);
    }
  }

  void dislikePost() {
    userDisLiked = !userDisLiked;
    DatabaseService(uid: user.uid)
        .updateUserLikedDisLikedData(latLng, id, userLiked, userDisLiked);
    if (userDisLiked) {
      DatabaseService(uid: user.uid).updateAreaDisLikesData(latLng, id, true);
    } else {
      DatabaseService(uid: user.uid).updateAreaDisLikesData(latLng, id, false);
    }

    if (userLiked) {
      userLiked = !userLiked;
      DatabaseService(uid: user.uid)
          .updateUserLikedDisLikedData(latLng, id, userLiked, userDisLiked);
      DatabaseService(uid: user.uid).updateAreaLikesData(latLng, id, false);
    }
  }

  // void clash1() {
  //   if (likes == 1) {
  //     //if (likes > 0) {
  //     if (userDisLiked) {
  //       userLiked = !userLiked;
  //       // userLikeUpdate(userLiked)
  //       likes -= 1;
  //       // databaseLikeUpdate(-1)
  //       return;
  //     } else {
  //       return;
  //     }
  //   }
  // }
  //
  // void clash2() {
  //   if (dislikes == 1) {
  //     if (userLiked) {
  //       userDisLiked = !userDisLiked;
  //       // userDislikeUpdate(userDisliked)
  //       dislikes -= 1;
  //       // databaseDislikeUpdate(-1)
  //       return;
  //     } else {
  //       return;
  //     }
  //   }
  // }
}