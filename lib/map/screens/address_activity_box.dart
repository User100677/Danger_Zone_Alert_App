import 'package:danger_zone_alert/comment/comment.dart';
import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/randomization.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/new_rating.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../util/calculate_distance.dart';
import '../widgets/alert_dialog.dart';

class AddressActivityBox extends StatelessWidget {
  final UserModel user;
  final String description;
  final Function boxCallback;

  final Area area;

  const AddressActivityBox({
    Key? key,
    required this.description,
    required this.user,
    required this.boxCallback,
    required this.area,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool previewRating = area.totalUsers > 10;
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
              previewRating ? Container() : const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                    previewRating
                        ? area.rating.toString()
                        : 'Threshold not Met',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: previewRating ? 50.0 : 30,
                        color: area.color,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'RobotoMono'),
                    textAlign: TextAlign.center),
              ),
              previewRating ? Container() : const SizedBox(height: 8),
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
                      rating: previewRating ? area.rating : 0.0,
                      itemBuilder: (BuildContext context, int index) =>
                          const Icon(Icons.star_border,
                              color: Color(0xffFEBC48)),
                      itemCount: 5,
                      itemSize: 18.0,
                      direction: Axis.horizontal)),
              // People Rated
              Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text('${area.totalUsers}  People Rated',
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
                    // Rate Button
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Rate',
                        buttonStyle: kBlueButtonStyle,
                        textColor: textColor,
                        onPressed: () {
                          if (user.access == false) {
                            showAlertDialog(context, kLocationDenied);
                          } else {
                            if (calculateDistance(user.latLng, area.latLng) <
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
                    // Comment Button
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Comment',
                        buttonStyle: kBlueButtonStyle,
                        textColor: textColor,
                        onPressed: () {
                          if (user.access == false) {
                            showAlertDialog(context, kLocationDenied);
                          } else {
                            if (calculateDistance(user.latLng, area.latLng) <
                                1) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                          user: user,
                                          area: area,
                                          areaIndex: areaList.indexOf(area))));
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
        .updateUserRatedAreasData(area.latLng, randomRating);

    await DatabaseService(uid: user.uid).updateAreasData(
        area.latLng,
        randomRating,
        colorAssignment(randomRating, randomTotalUsers),
        randomTotalUsers);

    print('Rating completed!');
  }
}
