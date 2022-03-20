import 'package:danger_zone_alert/comment/comment.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/randomization.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/new_rating.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/calculate_distance.dart';
import '../widgets/alert_dialog.dart';

class AddressActivityBox extends StatelessWidget {
  final Color color;
  final bool preview;
  final double rating;
  final UserModel user;
  final int totalUsers;
  final LatLng areaLatLng;
  final String description;
  final Function boxCallback;

  const AddressActivityBox({
    Key? key,
    required this.description,
    required this.areaLatLng,
    required this.user,
    required this.totalUsers,
    required this.rating,
    required this.color,
    required this.boxCallback,
    required this.preview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.white;
    const locationTextColor = Color(0xff6E7CA8);
    const iconColor = Color(0xffAAB1C9);
    const containerButtonColor = Color(0xffF2F4F5);
    const textColor = Colors.white;

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
          decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            children: <Widget>[
              preview ? Container() : const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(preview ? rating.toString() : 'Threshold not Met',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: preview ? 50.0 : 30,
                        color: color,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotoMono'),
                    textAlign: TextAlign.center),
              ),
              preview ? Container() : const SizedBox(height: 8),
              Text('Danger Level',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: 18.0,
                      color: const Color(0xFFB71C1C),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              // Rating Bar
              Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: RatingBarIndicator(
                      rating: preview ? rating : 0.0,
                      itemBuilder: (BuildContext context, int index) =>
                          const Icon(Icons.star_border,
                              color: Color(0xffFEBC48)),
                      itemCount: 5,
                      itemSize: 18.0,
                      direction: Axis.horizontal)),
              // People Rated
              Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text('$totalUsers People Rated',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 10.0, color: locationTextColor),
                      textAlign: TextAlign.center)),
              // Container for location icon and description
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.location_on_outlined,
                            size: 24.0, color: iconColor)),
                    Flexible(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 14.0, color: locationTextColor),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Container for 'Rate' and 'Comment' button
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                decoration: const BoxDecoration(
                    color: containerButtonColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Rate',
                        buttonStyle: kBlueButtonStyle,
                        textColor: textColor,
                        onPressed: () {
                          if (user.access == false) {
                            showAlertDialog(context, kLocationDenied);
                          } else {
                            if (calculateDistance(user.latLng, areaLatLng) <
                                1) {
                              // TODO: Database
                              handleRatePressed();

                              Navigator.popAndPushNamed(
                                  context, RatingQuestionsList.id);
                              boxCallback();
                            } else {
                              showAlertDialog(context, kAlertRateText);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Comment',
                        buttonStyle: kBlueButtonStyle,
                        textColor: textColor,
                        onPressed: () {
                          if (user.access == false) {
                            showAlertDialog(context, kLocationDenied);
                          } else {
                            if (calculateDistance(user.latLng, areaLatLng) <
                                1) {
                              // TODO: Database
                              handleCommentPressed();

                              Navigator.popAndPushNamed(
                                  context, CommentScreen.id);
                              boxCallback();
                            } else {
                              showAlertDialog(context, kAlertCommentText);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  handleRatePressed() async {
    double randomRating = doubleInRange(2.0, 5.0);
    int randomTotalUsers = intInRange(3, 20);

    await DatabaseService(uid: user.uid)
        .updateUserRatedAreasData(areaLatLng, randomRating);

    await DatabaseService(uid: user.uid).updateAreasData(
        areaLatLng,
        randomRating,
        colorAssignment(randomRating, randomTotalUsers),
        randomTotalUsers);

    print('Rating completed!');
  }

  handleCommentPressed() async {
    await DatabaseService(uid: user.uid)
        .postAreasCommentData(areaLatLng, 'Testing123', user.email);

    print('Comment completed!');
  }
}
