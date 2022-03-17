import 'package:danger_zone_alert/auth/screens/welcome.dart';
import 'package:danger_zone_alert/models/area.dart';
import 'package:danger_zone_alert/services/database.dart';
import 'package:danger_zone_alert/shared/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/application_bloc.dart';
import 'map/screens/fire_map.dart';
import 'models/user.dart';

/* This widget decide whether to load WelcomeScreen widget or GoogleMapScreen widget
   depending on the value of the user depending on the userModel object.
*/

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assign userModel after log in
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const WelcomeScreen();
    } else {
      return Consumer<ApplicationBloc>(
        builder: (context, provider, child) => (provider.position == null)
            ? const Loading()
            : (provider.position is String)
                ? const FireMapScreen()
                // TODO: Database provider
                : MultiProvider(providers: [
                    StreamProvider<List<Area>>.value(
                        catchError: null,
                        initialData: const [],
                        value: DatabaseService().areas),
                    StreamProvider<List<RatedArea>>.value(
                        catchError: null,
                        initialData: const [],
                        value: DatabaseService().userRatedArea),
                  ], child: FireMapScreen(position: provider.position)),
      );
    }
  }
}
