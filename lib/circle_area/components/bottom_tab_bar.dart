import 'package:danger_zone_alert/services/auth.dart';
import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget {
  Function() onPressed;

  final AuthService _authService = AuthService();
  double height = 60;
  final primaryColor = Colors.blueAccent;
  final secondaryColor = const Color(0xff818181);
  final backgroundColor = Colors.white;

  BottomTabBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BottomAppBar(
          color: Colors.transparent,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, height),
                painter: BottomTabBarPainter(),
              ),
              // Current user location button
              Center(
                heightFactor: 0.6,
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  elevation: 10,
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                  ),
                  onPressed: onPressed,
                ),
              ),
              // NewsApi and logout icon button
              SizedBox(
                height: height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconBar(
                      icon: Icons.web_rounded,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 56),
                    IconBar(
                      icon: Icons.logout_rounded,
                      onPressed: () async {
                        await _authService.signOut();
                      },
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

// Tab Bar graphic canvas
class BottomTabBarPainter extends CustomPainter {
  Color backgroundColor;
  double elevation;
  double insetRadius;

  BottomTabBarPainter(
      {this.backgroundColor = Colors.white,
      this.insetRadius = 38,
      this.elevation = 100});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;

    path.lineTo(insetCurveBeginnningX, 0);
    path.arcToPoint(Offset(insetCurveEndX, 0),
        radius: const Radius.circular(41), clockwise: true);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height + 56);
    path.lineTo(0, size.height + 56);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// NewsAPI and LogOut Icon widget
class IconBar extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const IconBar({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            icon,
            size: 25.0,
            color: const Color(0xff818181),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
