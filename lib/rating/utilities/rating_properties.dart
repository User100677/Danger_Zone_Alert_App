import 'package:danger_zone_alert/shared/constants/app_constants.dart';

// Colour assignment for the circle based on the rating value
int colorAssignment(double ratingValue, int totalUsers) {
  if (totalUsers < kUserThreshold) {
    return kAreaColors[0];
  }

  if (ratingValue < 3.0) {
    return kAreaColors[1];
  } else if (ratingValue < 3.5) {
    return kAreaColors[2];
  } else if (ratingValue < 4.0) {
    return kAreaColors[3];
  } else if (ratingValue <= 5.0) {
    return kAreaColors[4];
  }

  return kAreaColors[0];
}
