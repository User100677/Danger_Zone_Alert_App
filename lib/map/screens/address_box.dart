import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/util/calculate_distance.dart';
import 'package:danger_zone_alert/map/widgets/alert_dialog.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/rating.dart';
import 'package:danger_zone_alert/shared/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressBox extends StatelessWidget {
  final LatLng latLng;
  final UserModel user;
  final String description;
  final Function boxCallback;

  const AddressBox(
      {Key? key,
      required this.description,
      required this.latLng,
      required this.user,
      required this.boxCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.white;
    const locationTextColor = Colors.black;
    const iconColor = Colors.lightBlueAccent;
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.location_on_outlined,
                            size: 28.0, color: iconColor)),
                    Flexible(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 16.0, color: locationTextColor),
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
                            if (calculateDistance(user.latLng, latLng) < 1) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RatingScreen(
                                            null,
                                            latLng,
                                            user: user,
                                          )));
                              boxCallback();
                            } else {
                              showAlertDialog(context, kAlertRateText);
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
}
