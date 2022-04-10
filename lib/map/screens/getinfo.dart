
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/map/screens/address_activity_box.dart';
import 'package:danger_zone_alert/map/screens/piechart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danger_zone_alert/map/screens/piechart.dart';
import 'package:flutter/rendering.dart';

class getinfo extends StatelessWidget {
  final String state;

  getinfo(this.state);

  @override
  Widget build(BuildContext context) {
    CollectionReference info = FirebaseFirestore.instance.collection('states_info');

    return FutureBuilder<DocumentSnapshot>(
      future: info.doc(state).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
                child: piechart(
                    title: 'idk',
                    robbery: data['robbery'],
                    injury: data['causingInjury'],
                    rape: data['rape'],
                    murder: data['murder'])),
            SizedBox(
              height: 22,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ]);
        }

        return Text("loading");
      },
    );
  }
}

