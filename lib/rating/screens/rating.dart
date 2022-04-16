import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/models/user.dart';
import 'package:danger_zone_alert/rating/utilities/rating_properties.dart';
import 'package:danger_zone_alert/rating/widgets/icon_alert.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/widget_view/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RatingScreen extends StatefulWidget {
  final UserModel user;
  final Area? area;
  final LatLng? latLng;

  const RatingScreen(this.area, this.latLng, {Key? key, required this.user})
      : super(key: key);

  @override
  RatingScreenController createState() => RatingScreenController();
}

// Rating Controller
class RatingScreenController extends State<RatingScreen> {
  late double _rating;
  late double _rating2;
  late double _rating3;
  late double finalRating;
  late double finalRating2;
  late double finalRating3;

  String text1 = 'No';
  String text2 = 'Five or more spots';
  String text3 = 'None';

  final double _initialRating = 0.0;
  final double _initialRating2 = 0.0;
  final double _initialRating3 = 0.0;

  List<double> valueOption = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0];

  final answerDescription = [
    'No',
    'Very Dim',
    'Dim',
    'Average',
    'Well Lit',
    'Very Well Lit',
    'Five or more spots',
    'Four spots',
    'Three spots',
    'Two spots',
    'One spot',
    'None',
    'None',
    'Only one',
    'Two',
    'Three',
    'Four',
    'Five or more'
  ];

  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
    _rating2 = _initialRating2;
    _rating3 = _initialRating3;
  }

  handleInfoButtonPressed() {
    showDialog<IconData>(
        context: context, builder: (context) => const IconAlert());
  }

  handleRatingBar1(rating) {
    setState(() {
      _rating = rating;
      if (_rating == valueOption[0]) {
        text1 = answerDescription[0];
      } else if (_rating == valueOption[1]) {
        text1 = answerDescription[1];
      } else if (_rating == valueOption[2]) {
        text1 = answerDescription[2];
      } else if (_rating == valueOption[3]) {
        text1 = answerDescription[3];
      } else if (_rating == valueOption[4]) {
        text1 = answerDescription[4];
      } else if (_rating == valueOption[5]) {
        text1 = answerDescription[5];
      }
    });
  }

  handleRatingBar2(rating) {
    setState(() {
      _rating2 = rating;
      if (_rating2 == valueOption[0]) {
        text2 = answerDescription[6];
      } else if (_rating2 == valueOption[1]) {
        text2 = answerDescription[7];
      } else if (_rating2 == valueOption[2]) {
        text2 = answerDescription[8];
      } else if (_rating2 == valueOption[3]) {
        text2 = answerDescription[9];
      } else if (_rating2 == valueOption[4]) {
        text2 = answerDescription[10];
      } else if (_rating2 == valueOption[5]) {
        text2 = answerDescription[11];
      }
    });
  }

  handleRatingBar3(rating) {
    setState(() {
      _rating3 = rating;
      if (_rating3 == valueOption[0]) {
        text3 = answerDescription[12];
      } else if (_rating3 == valueOption[1]) {
        text3 = answerDescription[13];
      } else if (_rating3 == valueOption[2]) {
        text3 = answerDescription[14];
      } else if (_rating3 == valueOption[3]) {
        text3 = answerDescription[15];
      } else if (_rating3 == valueOption[4]) {
        text3 = answerDescription[16];
      } else if (_rating3 == valueOption[5]) {
        text3 = answerDescription[17];
      }
    });
  }

  handleSubmitPressed() async {
    if (_rating == valueOption[0]) {
      finalRating = valueOption[5];
    } else if (_rating == valueOption[1]) {
      finalRating = valueOption[4];
    } else if (_rating == valueOption[2]) {
      finalRating = valueOption[3];
    } else if (_rating == valueOption[3]) {
      finalRating = valueOption[2];
    } else if (_rating == valueOption[4]) {
      finalRating = valueOption[1];
    } else if (_rating == valueOption[5]) {
      finalRating = valueOption[0];
    }

    if (_rating2 == valueOption[0]) {
      finalRating2 = valueOption[5];
    } else if (_rating2 == valueOption[1]) {
      finalRating2 = valueOption[4];
    } else if (_rating2 == valueOption[2]) {
      finalRating2 = valueOption[3];
    } else if (_rating2 == valueOption[3]) {
      finalRating2 = valueOption[2];
    } else if (_rating2 == valueOption[4]) {
      finalRating2 = valueOption[1];
    } else if (_rating2 == valueOption[5]) {
      finalRating2 = valueOption[0];
    }

    if (_rating3 == valueOption[0]) {
      finalRating3 = valueOption[5];
    } else if (_rating3 == valueOption[1]) {
      finalRating3 = valueOption[4];
    } else if (_rating3 == valueOption[2]) {
      finalRating3 = valueOption[3];
    } else if (_rating3 == valueOption[3]) {
      finalRating3 = valueOption[2];
    } else if (_rating3 == valueOption[4]) {
      finalRating3 = valueOption[1];
    } else if (_rating3 == valueOption[5]) {
      finalRating3 = valueOption[0];
    }

    List<double> questionWeightage = [3.73, 2.72, 3.15];

    double totalQuestionWeightage =
        questionWeightage[0] + questionWeightage[1] + questionWeightage[2];

    double rate = ((questionWeightage[0] * finalRating) +
            (questionWeightage[1] * finalRating2) +
            (questionWeightage[2] * finalRating3)) /
        totalQuestionWeightage;

    databaseRatingCalculation(double.parse(rate.toStringAsFixed(2)));

    print("The rating given by the user is: " + rate.toString());
    print('Rating completed!');

    // showAlertDialogBox(AlertType.success, 'Rating Completed', '', '', context);
    Alert(
      context: context,
      type: AlertType.success,
      title: 'Rating Completed!',
      buttons: [
        DialogButton(
          child: const Text(
            "Got it",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.lightBlueAccent,
          width: 120,
        ),
      ],
    ).show().whenComplete(() => Navigator.pop(context));
  }

  databaseRatingCalculation(rate) async {
    if (widget.area != null) {
      Area? area = widget.area;

      if (area!.totalUsers > 0) {
        double totalRating = area.rating * area.totalUsers;

        // If user Re-rate the area
        if (widget.user.ratedAreas.isNotEmpty &&
            widget.user.ratedAreas.first.latLng == area.latLng) {
          totalRating =
              totalRating - widget.user.ratedAreas.first.rating + rate;

          double resultRating = totalRating / area.totalUsers;

          resultRating = double.parse(resultRating.toStringAsFixed(2));

          await DatabaseService(uid: widget.user.uid).updateAreaData(
              area.latLng,
              resultRating,
              colorAssignment(resultRating, area.totalUsers),
              area.totalUsers);
        } else {
          int newTotalUsers = area.totalUsers + 1;
          totalRating = totalRating + rate;
          double resultRating = totalRating / newTotalUsers;
          resultRating = double.parse(resultRating.toStringAsFixed(2));

          await DatabaseService(uid: widget.user.uid).updateAreaData(
              area.latLng,
              resultRating,
              colorAssignment(resultRating, newTotalUsers),
              newTotalUsers);
        }

        await DatabaseService(uid: widget.user.uid)
            .updateUserRatingData(area.latLng, rate);
      }
    } else {
      if (widget.latLng != null) {
        await DatabaseService(uid: widget.user.uid)
            .updateAreaData(widget.latLng!, rate, colorAssignment(0, 1), 1);

        await DatabaseService(uid: widget.user.uid)
            .updateUserRatingData(widget.latLng!, rate);
      }
    }
  }

  @override
  Widget build(BuildContext context) => _RatingScreenView(this);
}

// Rating View
class _RatingScreenView
    extends WidgetView<RatingScreen, RatingScreenController> {
  _RatingScreenView(RatingScreenController state) : super(state);
  final questionsTitle = [
    '1. Is the area well lit?',
    '2. Are there any clustered/hidden space in the area that can hide gathering of people?',
    '3. Are there any crime prevention utilities in the area? (e.g. safety mirror, police booth, etc.)',
  ];

  final bool _isRTLMode = false;
  final bool _isVertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAE0E6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Area Rating Page',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:
              const Icon(Icons.arrow_back_sharp, size: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help, size: 25),
            color: Colors.white,
            onPressed: () {
              state.handleInfoButtonPressed();
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  elevation: 5.0,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(children: [
                        Expanded(child: _heading(questionsTitle[0]))
                      ]),
                      const SizedBox(height: 20.0),
                      _ratingBar(context, state._initialRating,
                          state.handleRatingBar1),
                      const SizedBox(height: 20.0),
                      Text('Rating Description: ${state.text1}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30.0),
                    ],
                  )),
              Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  elevation: 5.0,
                  child: Column(
                    children: [
                      _heading(questionsTitle[1]),
                      const SizedBox(height: 20.0),
                      _ratingBar(context, state._initialRating2,
                          state.handleRatingBar2),
                      const SizedBox(height: 20.0),
                      Text('Rating Description: ${state.text2}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30.0),
                    ],
                  )),
              Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  elevation: 5.0,
                  child: Column(
                    children: [
                      _heading(questionsTitle[2]),
                      const SizedBox(height: 20.0),
                      _ratingBar(context, state._initialRating3,
                          state.handleRatingBar3),
                      const SizedBox(height: 20.0),
                      Text('Rating Description: ${state.text3}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40.0),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  state.handleSubmitPressed();
                },
                child: const Text('Rate',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(context, initialRating, Function onUpdate) {
    return RatingBar.builder(
        initialRating: initialRating,
        minRating: 0,
        direction: _isVertical ? Axis.vertical : Axis.horizontal,
        allowHalfRating: false,
        unratedColor: Colors.blue.withAlpha(50),
        itemCount: 5,
        itemSize: 35.0,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.blue),
        onRatingUpdate: (rating) {
          onUpdate(rating);
        },
        updateOnDrag: true);
  }

  Widget _heading(String text) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 18.0),
                textAlign: TextAlign.justify),
          )
        ],
      );
}
