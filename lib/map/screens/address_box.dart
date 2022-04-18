import 'package:danger_zone_alert/map/utilities/calculate_distance.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/screens/rating.dart';
import 'package:danger_zone_alert/shared/constants/app_constants.dart';
import 'package:danger_zone_alert/shared/widgets/alert_dialog_box.dart';
import 'package:danger_zone_alert/shared/widgets/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'info_box.dart';

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
                            showAlertDialogBox(
                                AlertType.error,
                                kLocationDeniedTitleText,
                                kLocationDeniedDescriptionText,
                                kLocationDeniedHintText,
                                context);
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
                    Expanded(
                        child: RoundedRectangleButton(
                      buttonText: 'Info',
                      buttonStyle: kBlueButtonStyle,
                      textColor: textColor,
                      onPressed: () async {
                        Navigator.pop(context);
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                latLng.latitude, latLng.longitude);
                        Placemark place = placemarks[0];
                        String state = place.administrativeArea!;

                        print(state);

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
