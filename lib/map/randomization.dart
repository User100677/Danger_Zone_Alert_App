import 'dart:math';

// random a double value with 2 decimal point
final _random = Random();

double doubleInRange(num start, num end) {
  double dRand = _random.nextDouble() * (end - start) + start;
  return double.parse(dRand.toStringAsPrecision(2));
}

int intInRange(int min, int max) => min + _random.nextInt(max - min);

// totalUsers < 10 is gray, 0 ~ 3 is green, 3 - 3.5 is yellow, 3.5 - 4.0 is orange 4.0 and above is red
// Grey, green, yellow, orange, red
List<int> colors = const [
  0xFF000000,
  0xFF1B5E20,
  0xFFE65100,
  0xFFF57F17,
  0xFFB71C1C,
];

int colorAssignment(double ratingValue, int totalUsers) {
  if (totalUsers < 10) {
    return colors[0];
  }

  if (ratingValue <= 3.0) {
    return colors[1];
  } else if (ratingValue <= 3.5) {
    return colors[2];
  } else if (ratingValue <= 4.0) {
    return colors[3];
  } else if (ratingValue <= 5.0) {
    return colors[4];
  }

  return colors[0];
}
