import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danger_zone_alert/map/widgets/state_info_pie_chart.dart';
import 'package:danger_zone_alert/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class GetInfo extends StatelessWidget {
  final String state;

  GetInfo(this.state);

  @override
  Widget build(BuildContext context) {
    CollectionReference info =
        FirebaseFirestore.instance.collection('states_info');

    return FutureBuilder<DocumentSnapshot>(
      future: info.doc(state).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SizedBox(
              height: 450,
              child: StateInfoPieChart(
                  title: state,
                  robbery: data['robbery'],
                  injury: data['causingInjury'],
                  rape: data['rape'],
                  murder: data['murder'],
                  totalCrime: data['totalCrime']),
            ),
            Text(
              'Total crime count: ' + data['totalCrime'].toString(),
              style: TextStyle(fontSize: 16.0, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK', style: TextStyle(fontSize: 18))),
            ),
          ]);
        }
        return const Loading();
      },
    );
  }
}
