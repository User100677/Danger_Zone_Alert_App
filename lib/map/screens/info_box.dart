import 'package:danger_zone_alert/constants/app_constants.dart';
import 'package:danger_zone_alert/map/widgets/getinfo.dart';
import 'package:flutter/material.dart';

class StateInfoBox extends StatelessWidget {
  final String state, text;

  const StateInfoBox({Key? key, required this.state, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(kPadding)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(
                left: kPadding,
                top: kAvatarRadius + kPadding,
                right: kPadding,
                bottom: kPadding),
            margin: const EdgeInsets.only(top: kAvatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(kPadding),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: GetInfo(state)),
        Positioned(
          left: kPadding,
          right: kPadding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: kAvatarRadius,
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(kAvatarRadius)),
                child: Image.asset("assets/images/exclamation_icon.jpg")),
          ),
        ),
      ],
    );
  }
}
