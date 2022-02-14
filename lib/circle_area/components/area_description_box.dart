import 'package:danger_zone_alert/comment/comment.dart';
import 'package:danger_zone_alert/rating/new_rating.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../area.dart';

class AreaDescriptionBox extends StatelessWidget {
  final Area area;
  final String areaDescription;
  final LatLng areaLatLng;
  final Function boxCallback;

  final primaryColor = Colors.white;
  final locationTextColor = Colors.black;
  final iconColor = Colors.lightBlueAccent;
  final containerButtonColor = const Color(0xffF2F4F5);
  final buttonColor = const Color(0xff367CFF);
  final buttonOutlineColor = const Color(0xff367CFF);
  final pressedColor = Colors.blue;
  final textColor = Colors.white;

  AreaDescriptionBox(
      {required this.area,
      required this.areaDescription,
      required this.areaLatLng,
      required this.boxCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 28.0,
                        color: iconColor,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        areaDescription,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontSize: 16.0,
                              color: locationTextColor,
                            ),
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
                decoration: BoxDecoration(
                  color: containerButtonColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Rate',
                        buttonColor: buttonColor,
                        buttonOutlineColor: buttonOutlineColor,
                        pressedColor: pressedColor,
                        textColor: textColor,
                        onPressed: () {
                          area.addCircle(areaLatLng);
                          Navigator.popAndPushNamed(
                              context, RatingQuestionsList.id);
                          // Navigator.pop(context);
                          boxCallback();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: RoundedRectangleButton(
                        buttonText: 'Comment',
                        buttonColor: buttonColor,
                        buttonOutlineColor: buttonOutlineColor,
                        pressedColor: pressedColor,
                        textColor: textColor,
                        onPressed: () {
                          area.addCircle(areaLatLng);
                          Navigator.popAndPushNamed(context, Comment.id);
                          // Navigator.pop(context);
                          boxCallback();
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
}
