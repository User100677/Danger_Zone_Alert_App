import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(const RatingQuestionsList());

class RatingQuestionsList extends StatefulWidget {
  static String id = "rating_screen";
  const RatingQuestionsList({Key? key}) : super(key: key);

  @override
  _RatingQuestionsListState createState() => _RatingQuestionsListState();
}

class _RatingQuestionsListState extends State<RatingQuestionsList> {
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
  final bool _isRTLMode = false;
  final bool _isVertical = false;

  final questionsTitle = [
    '1. Is the area well lit?',
    '2. Are there any clustered/hidden space in the area that can hide gathering of people?',
    '3. Are there any crime prevention utilities in the area? (e.g. safety mirror, police booth, etc.)',
  ];

  List <double> valueOption = [0.0,1.0,2.0,3.0,4.0,5.0];

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Rating Page'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                size: 25,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help, size: 25),
                color: Colors.white,
                onPressed: () {
                  showDialog<IconData>(
                    context: context,
                    builder: (context) => const IconAlert(),
                  );
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  _heading(questionsTitle[0]),
                  const SizedBox(height: 20.0),
                  _ratingBar(),
                  const SizedBox(height: 20.0),
                  Text(
                    'Rating Description: $text1',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 30.0,
                  ),
                  _heading(questionsTitle[1]),
                  const SizedBox(height: 20.0),
                  _ratingBar2(),
                  const SizedBox(height: 20.0),
                  Text(
                    'Rating Description: $text2',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 30.0,
                  ),
                  _heading(questionsTitle[2]),
                  const SizedBox(height: 20.0),
                  _ratingBar3(),
                  const SizedBox(height: 20.0),
                  Text(
                    'Rating Description: $text3',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: (){
                      if(_rating == valueOption[0]) {
                        finalRating = valueOption[5];
                      } else if (_rating == valueOption[1]){
                        finalRating = valueOption[4];
                      } else if (_rating == valueOption[2]){
                        finalRating = valueOption[3];
                      } else if (_rating == valueOption[3]){
                        finalRating = valueOption[2];
                      } else if (_rating == valueOption[4]){
                        finalRating = valueOption[1];
                      } else if (_rating == valueOption[5]){
                        finalRating = valueOption[0];
                      }

                      if(_rating2 == valueOption[0]) {
                        finalRating2 = valueOption[5];
                      } else if (_rating2 == valueOption[1]){
                        finalRating2 = valueOption[4];
                      } else if (_rating2 == valueOption[2]){
                        finalRating2 = valueOption[3];
                      } else if (_rating2 == valueOption[3]){
                        finalRating2 = valueOption[2];
                      } else if (_rating2 == valueOption[4]){
                        finalRating2 = valueOption[1];
                      } else if (_rating2 == valueOption[5]){
                        finalRating2 = valueOption[0];
                      }

                      if(_rating3 == valueOption[0]) {
                        finalRating3 = valueOption[5];
                      } else if (_rating3 == valueOption[1]){
                        finalRating3 = valueOption[4];
                      } else if (_rating3 == valueOption[2]){
                        finalRating3 = valueOption[3];
                      } else if (_rating3 == valueOption[3]){
                        finalRating3 = valueOption[2];
                      } else if (_rating3 == valueOption[4]){
                        finalRating3 = valueOption[1];
                      } else if (_rating3 == valueOption[5]){
                        finalRating3 = valueOption[0];
                      }

                      double rate = ((3.73*finalRating)+(2.72*finalRating2)+(3.15*finalRating3))/9.6;
                      print(rate.toStringAsFixed(2));
                    },
                    child: const Text('Rate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize:MaterialStateProperty.all(const Size(200, 40)),

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      initialRating: _initialRating,
      minRating: 0,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.blue.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.blue,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
          if(_rating == valueOption[0]) {
            text1 = answerDescription[0];
          } else if (_rating == valueOption[1]){
            text1 = answerDescription[1];
          } else if (_rating == valueOption[2]){
            text1 = answerDescription[2];
          } else if (_rating == valueOption[3]){
            text1 = answerDescription[3];
          } else if (_rating == valueOption[4]){
            text1 = answerDescription[4];
          } else if (_rating == valueOption[5]){
            text1 = answerDescription[5];
          }
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _ratingBar2() {
    return RatingBar.builder(
      initialRating: _initialRating2,
      minRating: 0,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.blue.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.blue,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating2 = rating;
          if(_rating2 == valueOption[0]) {
            text2 = answerDescription[6];
          } else if (_rating2 == valueOption[1]){
            text2 = answerDescription[7];
          } else if (_rating2 == valueOption[2]){
            text2 = answerDescription[8];
          } else if (_rating2 == valueOption[3]){
            text2 = answerDescription[9];
          } else if (_rating2 == valueOption[4]){
            text2 = answerDescription[10];
          } else if (_rating2 == valueOption[5]){
            text2 = answerDescription[11];
          }
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _ratingBar3() {
    return RatingBar.builder(
      initialRating: _initialRating3,
      minRating: 0,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: false,
      unratedColor: Colors.blue.withAlpha(50),
      itemCount: 5,
      itemSize: 35.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.blue,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating3 = rating;
          if(_rating3 == valueOption[0]) {
            text3 = answerDescription[12];
          } else if (_rating3 == valueOption[1]){
            text3 = answerDescription[13];
          } else if (_rating3 == valueOption[2]){
            text3 = answerDescription[14];
          } else if (_rating3 == valueOption[3]){
            text3 = answerDescription[15];
          } else if (_rating3 == valueOption[4]){
            text3 = answerDescription[16];
          } else if (_rating3 == valueOption[5]){
            text3 = answerDescription[17];
          }
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _heading(String text) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 5,10, 5),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.justify,
        ),
      )

    ],
  );
}

class IconAlert extends StatelessWidget {
  const IconAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Welcome to the Rating Page!',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 24.0,
        ),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titlePadding: const EdgeInsets.all(12.0),
      contentPadding: const EdgeInsets.all(12.0),
      content: Wrap(
        children: const [
          Text('The purpose of this feature is to let the user rate the safety level of an area based on the feature of safe city implemented by the government.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          Text('\n\n Let\'s Create a Safer Place Together!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19.0,
            ),
            textAlign: TextAlign.center,
          ),
          Text('\n\n Hint: To clear out the rating of a question, click twice on the first star of the question.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text('Close', textAlign: TextAlign.center))
      ],
    );
  }
}