import 'package:danger_zone_alert/comment/screens/comment.dart';
import 'package:danger_zone_alert/map/utilities/calculate_distance.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/screens/rating.dart';
import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/alert_dialog_box.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'info_box.dart';

class AddressActivityBox extends StatelessWidget {
  final Area area;
  final UserModel user;
  final String description;
  final Function boxCallback;

  const AddressActivityBox({
    Key? key,
    required this.description,
    required this.user,
    required this.boxCallback,
    required this.area,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool previewRating = area.totalUsers >= kUserThreshold;
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
                child: RichText(
                  text: TextSpan(
                    text: previewRating
                        ? area.rating.toStringAsFixed(1)
                        : 'Required threshold not met',
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: previewRating ? 50.0 : 22,
                        color: area.color,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'RobotoMono'),
                    children: <TextSpan>[
                      TextSpan(
                          text: previewRating ? ' / 5' : '',
                          style: const TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'RobotoMono')),
                    ],
                  ),
                ),
              ),
              previewRating ? Container() : const SizedBox(height: 8),
              Text('Crime Level',
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
                          ?.copyWith(fontSize: 11.0, color: locationTextColor),
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
                            showAlertDialogBox(
                                AlertType.error,
                                kLocationDeniedTitleText,
                                kLocationDeniedDescriptionText,
                                kLocationDeniedHintText,
                                context);
                          } else {
                            if (calculateDistance(user.latLng, area.latLng) <
                                1) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RatingScreen(
                                          area, null,
                                          user: user)));
                              boxCallback();
                            } else {
                              showAlertDialogBox(
                                  AlertType.warning,
                                  kLocationOutOfBoundTitleText,
                                  kLocationOutOfBoundDescriptionText,
                                  kLocationOutOfBoundHintText,
                                  context);
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
                            showAlertDialogBox(
                                AlertType.error,
                                kLocationDeniedTitleText,
                                kLocationDeniedDescriptionText,
                                kLocationDeniedHintText,
                                context);
                          } else {
                            bool permission =
                                calculateDistance(user.latLng, area.latLng) < 1
                                    ? true
                                    : false;

                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                          user: user,
                                          area: area,
                                          permission: permission,
                                        )));
                            boxCallback();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                        child: RoundedRectangleButton(
                      buttonText: 'Info',
                      buttonStyle: kBlueButtonStyle,
                      textColor: textColor,
                      onPressed: () async {
                        Navigator.pop(context);
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                area.latLng.latitude, area.latLng.longitude);
                        Placemark place = placemarks[0];
                        String state = place.administrativeArea!;

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StateInfoBox(state: state, text: "OK");
                            }); // showdialog box
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
