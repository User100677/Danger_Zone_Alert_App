import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class Rating extends StatelessWidget {
//   const Rating({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Danger Zone Alert App',
//       theme: ThemeData(),
//       home: RatingQuestionsList(),
//     );
//   }
// }

class RatingQuestionsList extends StatefulWidget {
  static String id = "rating_screen";
  const RatingQuestionsList({Key? key}) : super(key: key);

  @override
  _RatingQuestionsListState createState() => _RatingQuestionsListState();
}

class _RatingQuestionsListState extends State<RatingQuestionsList> {
  int rate1 = 0, rate2 = 0, rate3 = 0, rate4 = 0, rate5 = 0;

  List<bool> valueOption = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final questionsTitle = [
    '1. Is the current circle_area well lit by the street lights?',
    '2. What is the amount of traffic in the current circle_area? (amount of human and vehicle passing through the circle_area)',
    '3. What is the rate of occurrence of malicious activities in this circle_area? (e.g. robbery, theft, etc.)',
    '4. What is the rate of occurrence of gang activities in this circle_area?',
    '5. How often does traffic accidents happen in this circle_area?'
  ];
  final answerOptions = [
    'No',
    'Very Dim',
    'Dim',
    'Average',
    'Well Lit',
    'Very Well Lit',
    'None',
    'Very Minimal',
    'Minimal',
    'Average',
    'Heavy Traffic',
    'Very Heavy Traffic',
    'None',
    'Very Rarely',
    'Rarely',
    'Quite Often',
    'Often',
    'Very Often',
    'None',
    'Very Rarely',
    'Rarely',
    'Quite Often',
    'Often',
    'Very Often',
    'None',
    'Very Rarely',
    'Rarely',
    'Quite Often',
    'Often',
    'Very Often'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            ListTile(
                title: Text(questionsTitle[0],
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)),
                subtitle: Card(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(answerOptions[0],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[0],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[0] == false) {
                              valueOption[0] = true;
                              valueOption[1] = false;
                              valueOption[2] = false;
                              valueOption[3] = false;
                              valueOption[4] = false;
                              valueOption[5] = false;
                              rate1 = 0;
                            } else {
                              valueOption[0] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[1],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[1],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[1] == false) {
                              valueOption[0] = false;
                              valueOption[1] = true;
                              valueOption[2] = false;
                              valueOption[3] = false;
                              valueOption[4] = false;
                              valueOption[5] = false;
                              rate1 = 1;
                            } else {
                              valueOption[1] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[2],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[2],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[2] == false) {
                              valueOption[0] = false;
                              valueOption[1] = false;
                              valueOption[2] = true;
                              valueOption[3] = false;
                              valueOption[4] = false;
                              valueOption[5] = false;
                              rate1 = 2;
                            } else {
                              valueOption[2] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[3],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[3],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[3] == false) {
                              valueOption[0] = false;
                              valueOption[1] = false;
                              valueOption[2] = false;
                              valueOption[3] = true;
                              valueOption[4] = false;
                              valueOption[5] = false;
                              rate1 = 3;
                            } else {
                              valueOption[3] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[4],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[4],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[4] == false) {
                              valueOption[0] = false;
                              valueOption[1] = false;
                              valueOption[2] = false;
                              valueOption[3] = false;
                              valueOption[4] = true;
                              valueOption[5] = false;
                              rate1 = 4;
                            } else {
                              valueOption[4] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[5],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[5],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[5] == false) {
                              valueOption[0] = false;
                              valueOption[1] = false;
                              valueOption[2] = false;
                              valueOption[3] = false;
                              valueOption[4] = false;
                              valueOption[5] = true;
                              rate1 = 5;
                            } else {
                              valueOption[5] = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            ListTile(
                title: Text(questionsTitle[1],
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)),
                subtitle: Card(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(answerOptions[6],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[6],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[6] == false) {
                              valueOption[6] = true;
                              valueOption[7] = false;
                              valueOption[8] = false;
                              valueOption[9] = false;
                              valueOption[10] = false;
                              valueOption[11] = false;
                              rate2 = 0;
                            } else {
                              valueOption[6] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[7],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[7],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[7] == false) {
                              valueOption[6] = false;
                              valueOption[7] = true;
                              valueOption[8] = false;
                              valueOption[9] = false;
                              valueOption[10] = false;
                              valueOption[11] = false;
                              rate2 = 1;
                            } else {
                              valueOption[7] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[8],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[8],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[8] == false) {
                              valueOption[6] = false;
                              valueOption[7] = false;
                              valueOption[8] = true;
                              valueOption[9] = false;
                              valueOption[10] = false;
                              valueOption[11] = false;
                              rate2 = 2;
                            } else {
                              valueOption[8] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[9],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[9],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[9] == false) {
                              valueOption[6] = false;
                              valueOption[7] = false;
                              valueOption[8] = false;
                              valueOption[9] = true;
                              valueOption[10] = false;
                              valueOption[11] = false;
                              rate2 = 3;
                            } else {
                              valueOption[9] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[10],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[10],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[10] == false) {
                              valueOption[6] = false;
                              valueOption[7] = false;
                              valueOption[8] = false;
                              valueOption[9] = false;
                              valueOption[10] = true;
                              valueOption[11] = false;
                              rate2 = 4;
                            } else {
                              valueOption[10] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[11],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[11],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[11] == false) {
                              valueOption[6] = false;
                              valueOption[7] = false;
                              valueOption[8] = false;
                              valueOption[9] = false;
                              valueOption[10] = false;
                              valueOption[11] = true;
                              rate2 = 5;
                            } else {
                              valueOption[11] = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            ListTile(
                title: Text(questionsTitle[2],
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)),
                subtitle: Card(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(answerOptions[12],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[12],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[12] == false) {
                              valueOption[12] = true;
                              valueOption[13] = false;
                              valueOption[14] = false;
                              valueOption[15] = false;
                              valueOption[16] = false;
                              valueOption[17] = false;
                              rate3 = 5;
                            } else {
                              valueOption[12] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[13],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[13],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[13] == false) {
                              valueOption[12] = false;
                              valueOption[13] = true;
                              valueOption[14] = false;
                              valueOption[15] = false;
                              valueOption[16] = false;
                              valueOption[17] = false;
                              rate3 = 4;
                            } else {
                              valueOption[13] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[14],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[14],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[14] == false) {
                              valueOption[12] = false;
                              valueOption[13] = false;
                              valueOption[14] = true;
                              valueOption[15] = false;
                              valueOption[16] = false;
                              valueOption[17] = false;
                              rate3 = 3;
                            } else {
                              valueOption[14] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[15],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[15],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[15] == false) {
                              valueOption[12] = false;
                              valueOption[13] = false;
                              valueOption[14] = false;
                              valueOption[15] = true;
                              valueOption[16] = false;
                              valueOption[17] = false;
                              rate3 = 2;
                            } else {
                              valueOption[15] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[16],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[16],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[16] == false) {
                              valueOption[12] = false;
                              valueOption[13] = false;
                              valueOption[14] = false;
                              valueOption[15] = false;
                              valueOption[16] = true;
                              valueOption[17] = false;
                              rate3 = 1;
                            } else {
                              valueOption[16] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[17],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[17],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[17] == false) {
                              valueOption[12] = false;
                              valueOption[13] = false;
                              valueOption[14] = false;
                              valueOption[15] = false;
                              valueOption[16] = false;
                              valueOption[17] = true;
                              rate3 = 0;
                            } else {
                              valueOption[17] = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            ListTile(
                title: Text(questionsTitle[3],
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)),
                subtitle: Card(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(answerOptions[18],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[18],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[18] == false) {
                              valueOption[18] = true;
                              valueOption[19] = false;
                              valueOption[20] = false;
                              valueOption[21] = false;
                              valueOption[22] = false;
                              valueOption[23] = false;
                              rate4 = 5;
                            } else {
                              valueOption[18] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[19],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[19],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[19] == false) {
                              valueOption[18] = false;
                              valueOption[19] = true;
                              valueOption[20] = false;
                              valueOption[21] = false;
                              valueOption[22] = false;
                              valueOption[23] = false;
                              rate4 = 4;
                            } else {
                              valueOption[19] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[20],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[20],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[20] == false) {
                              valueOption[18] = false;
                              valueOption[19] = false;
                              valueOption[20] = true;
                              valueOption[21] = false;
                              valueOption[22] = false;
                              valueOption[23] = false;
                              rate4 = 3;
                            } else {
                              valueOption[20] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[21],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[21],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[21] == false) {
                              valueOption[18] = false;
                              valueOption[19] = false;
                              valueOption[20] = false;
                              valueOption[21] = true;
                              valueOption[22] = false;
                              valueOption[23] = false;
                              rate4 = 2;
                            } else {
                              valueOption[21] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[22],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[22],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[22] == false) {
                              valueOption[18] = false;
                              valueOption[19] = false;
                              valueOption[20] = false;
                              valueOption[21] = false;
                              valueOption[22] = true;
                              valueOption[23] = false;
                              rate4 = 1;
                            } else {
                              valueOption[22] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[23],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[23],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[23] == false) {
                              valueOption[18] = false;
                              valueOption[19] = false;
                              valueOption[20] = false;
                              valueOption[21] = false;
                              valueOption[22] = false;
                              valueOption[23] = true;
                              rate4 = 0;
                            } else {
                              valueOption[23] = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            ListTile(
                title: Text(questionsTitle[4],
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold)),
                subtitle: Card(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(answerOptions[24],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[24],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[24] == false) {
                              valueOption[24] = true;
                              valueOption[25] = false;
                              valueOption[26] = false;
                              valueOption[27] = false;
                              valueOption[28] = false;
                              valueOption[29] = false;
                              rate5 = 5;
                            } else {
                              valueOption[24] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[25],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[25],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[25] == false) {
                              valueOption[24] = false;
                              valueOption[25] = true;
                              valueOption[26] = false;
                              valueOption[27] = false;
                              valueOption[28] = false;
                              valueOption[29] = false;
                              rate5 = 4;
                            } else {
                              valueOption[25] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[26],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[26],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[26] == false) {
                              valueOption[24] = false;
                              valueOption[25] = false;
                              valueOption[26] = true;
                              valueOption[27] = false;
                              valueOption[28] = false;
                              valueOption[29] = false;
                              rate5 = 3;
                            } else {
                              valueOption[26] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[27],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[27],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[27] == false) {
                              valueOption[24] = false;
                              valueOption[25] = false;
                              valueOption[26] = false;
                              valueOption[27] = true;
                              valueOption[28] = false;
                              valueOption[29] = false;
                              rate5 = 2;
                            } else {
                              valueOption[27] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[28],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[28],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[28] == false) {
                              valueOption[24] = false;
                              valueOption[25] = false;
                              valueOption[26] = false;
                              valueOption[27] = false;
                              valueOption[28] = true;
                              valueOption[29] = false;
                              rate5 = 1;
                            } else {
                              valueOption[28] = false;
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(answerOptions[29],
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black)),
                        value: valueOption[29],
                        onChanged: (bool? value) {
                          setState(() {
                            if (valueOption[29] == false) {
                              valueOption[24] = false;
                              valueOption[25] = false;
                              valueOption[26] = false;
                              valueOption[27] = false;
                              valueOption[28] = false;
                              valueOption[29] = true;
                              rate5 = 0;
                            } else {
                              valueOption[29] = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            Container(
              color: Colors.blue,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // replace this print statement with sending data to database
                      print((rate1 + rate2 + rate3 + rate4 + rate5) / 5);
                    },
                    child: const Text('Finish',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 40)),
                    ),
                  )
                ],
              ),
            ),
          ])),
    );
  }
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
