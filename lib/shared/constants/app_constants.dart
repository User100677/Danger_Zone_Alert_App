import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String kApiKey = "AIzaSyD6eM4LXUhjcLH8aqa-uTyd8AJ9OE_9c0c";

const String kSignUpText = 'Sign up';
const String kSignInText = 'Log in';

// Text for alert_dialog_box
const String kLocationDeniedTitleText = 'Requirement not met';

const String kLocationDeniedDescriptionText =
    'Rate & Comment functionality are disabled when location condition is not met.';

const String kLocationDeniedHintText =
    "Hint: User's GPS service is disabled or not within Malaysia.";

const String kLocationOutOfBoundTitleText = 'Location selected is too far!';

const String kLocationOutOfBoundDescriptionText =
    'Rate & Comment functionality are disabled when user location is out of bound.';

const String kLocationOutOfBoundHintText =
    'Hint: User can only rate & comment on area within 1.0km radius.';

const String kInvalidAddress = 'Invalid_Address';

/* --------------- Constant Variable --------------- */
final LatLngBounds kMalaysiaBounds = LatLngBounds(
    southwest: const LatLng(0.773131415201, 100.085756871),
    northeast: const LatLng(6.92805288332, 119.181903925));

const CameraPosition kInitialCameraPosition = CameraPosition(
    target: LatLng(4.445446291086245, 102.04430367797612), zoom: 7);

// Circle Radius 100.0 = 0.1km
const double kAreaRadius = 100.0;

/* --------------- Constant Widget Style --------------- */

// Button style for the auth page
ButtonStyle kWhiteButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Colors.white,
    elevation: 5,
    side: const BorderSide(
        color: Colors.grey, style: BorderStyle.solid, width: 1),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))));

// Button style for the auth page
ButtonStyle kLightBlueButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.lightBlueAccent,
    backgroundColor: Colors.lightBlueAccent,
    elevation: 5,
    side: const BorderSide(
        color: Colors.white, style: BorderStyle.solid, width: 1),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))));

// Button style for the description box in Google Map
ButtonStyle kBlueButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.blue,
    backgroundColor: const Color(0xff367CFF),
    elevation: 5,
    side: const BorderSide(
        color: Color(0xff367CFF), style: BorderStyle.solid, width: 1),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))));

// Database Constants
const int kUserThreshold = 10;

// totalUsers < 10 is gray, 0 ~ 3 is green, 3 - 3.5 is yellow, 3.5 - 4.0 is orange 4.0 and above is red
// Grey, green, yellow, orange, red
const List<int> kAreaColors = [
  0xFF000000, // gray
  0xFF1B5E20, // green
  0xFFE65100, // yellow
  0xFFF57F17, // orange
  0xFFB71C1C, // red
];

const double kPadding = 10;
const double kAvatarRadius = 45;
