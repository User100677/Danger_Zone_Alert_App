import 'package:flutter/material.dart';
import 'package:polls/polls.dart';

void main() {
  runApp(const MaterialApp(
    title: 'MyApp',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAP'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Enter ratings'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.orangeAccent,
            height: 50,
            width: 500,
            child: const Text('You can also choose the danger you want to report',
            style: TextStyle(fontSize: 20)),
          ),
         Expanded(
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
               color: Colors.white70,
               child: const PollView(),
             ),
         ),
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back!'),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

class PollView extends StatefulWidget{
  const PollView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child:
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: 200,
            width: 100,
            color: Colors.white,
          ),
      ),
    );
  }
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView>{
  double option1 = 0.0;
  double option2 = 0.0;
  double option3 = 0.0;
  double option4 = 0.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {'sam@mail.com': 3, 'mike@mail.com' : 4, 'john@mail.com' : 1, 'kenny@mail.com' : 1};
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Polls(
        children: [
          // This cannot be less than 2, else will throw an exception
          Polls.options(title: 'Robbery', value: option1),
          Polls.options(title: 'Gang activity', value: option2),
          Polls.options(title: 'Drug activity', value: option3),
          Polls.options(title: 'Other crimes', value: option4),
        ],
        question: const Text('Please select any of the following'),
        currentUser: user,
        creatorID: creator,
        voteData: usersWhoVoted,
        userChoice: usersWhoVoted[user],
        onVoteBackgroundColor: Colors.blue,
        leadingBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        onVote: (choice) {
          print(choice);
          setState(() {
            usersWhoVoted[user] = choice;
          });
          if (choice == 1) {
            setState(() {
              option1 += 1.0;
            });
          }
          if (choice == 2) {
            setState(() {
              option2 += 1.0;
            });
          }
          if (choice == 3) {
            setState(() {
              option3 += 1.0;
            });
          }
          if (choice == 4) {
            setState(() {
              option4 += 1.0;
            });
          }
        },
      ),
    );
  }
}

