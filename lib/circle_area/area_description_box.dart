import 'package:danger_zone_alert/login_signup/components/rounded_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'danger_area.dart';

class AreaDescriptionBox extends StatelessWidget {
  final DangerArea radius;
  final String areaDescription;
  final LatLng areaLatLng;
  final Function boxCallback;

  AreaDescriptionBox(
      {required this.radius,
      required this.areaDescription,
      required this.areaLatLng,
      required this.boxCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Container(
          //   padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
          //   child: Row(
          //     children: <Widget>[
          //       const Padding(
          //         padding: EdgeInsets.only(right: 12.0),
          //         child: Icon(
          //           Icons.location_on_sharp,
          //           color: Colors.lightBlueAccent,
          //         ),
          //       ),
          //       Flexible(
          //         child: Text(
          //           areaDescription,
          //           style: Theme.of(context).textTheme.bodyText2?.copyWith(
          //                 fontSize: 16.0,
          //               ),
          //           textAlign: TextAlign.left,
          //           maxLines: 3,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 28.0,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                Flexible(
                  child: Text(
                    areaDescription,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: const BoxDecoration(
              color: Color(0xffF2F4F5),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RoundedRectangleButton(
                    buttonText: 'Rate',
                    buttonColor: const Color(0xff367CFF),
                    buttonOutlineColor: const Color(0xff367CFF),
                    pressedColor: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      radius.addCircle(areaLatLng);
                      Navigator.pop(context);
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
                    buttonColor: const Color(0xff367CFF),
                    buttonOutlineColor: const Color(0xff367CFF),
                    pressedColor: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      radius.addCircle(areaLatLng);
                      Navigator.pop(context);
                      boxCallback();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
