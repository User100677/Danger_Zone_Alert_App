import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:danger_zone_alert/home/screens/home.dart';
import 'package:danger_zone_alert/map/screens/fire_map.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/news/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/*
  This screen act as an intermediary screen between Homepage, News page and
  Map page.
*/

class IntermediaryScreen extends StatefulWidget {
  final UserModel user;
  final Position? userPosition;
  const IntermediaryScreen({Key? key, required this.user, this.userPosition})
      : super(key: key);

  @override
  State<IntermediaryScreen> createState() => _IntermediaryScreenState();
}

class _IntermediaryScreenState extends State<IntermediaryScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens;
    if (widget.userPosition == null) {
      screens = [
        HomeScreen(user: widget.user),
        NewsScreen(),
        FireMapScreen(user: widget.user),
      ];
    } else {
      screens = [
        HomeScreen(user: widget.user),
        NewsScreen(),
        FireMapScreen(user: widget.user, userPosition: widget.userPosition),
      ];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
          child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [IndexedStack(index: _currentIndex, children: screens)],
      )),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text('Home'),
            activeColor: Colors.redAccent,
          ),
          BottomNavyBarItem(
              icon: const Icon(Icons.newspaper_rounded),
              title: const Text('News'),
              activeColor: Colors.blueAccent),
          BottomNavyBarItem(
              icon: const Icon(Icons.map_rounded),
              title: const Text('Map'),
              activeColor: Colors.greenAccent),
        ],
      ),
    );
  }
}
