import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

cameraMiddleCoordinate(context) {
  double screenWidth = MediaQuery.of(context).size.width *
      MediaQuery.of(context).devicePixelRatio;

  double screenHeight = MediaQuery.of(context).size.height *
      MediaQuery.of(context).devicePixelRatio;

  double middleX = screenWidth / 2;
  double middleY = screenHeight / 2;

  ScreenCoordinate screenCoordinate =
      ScreenCoordinate(x: middleX.round(), y: middleY.round());

  return screenCoordinate;
}
