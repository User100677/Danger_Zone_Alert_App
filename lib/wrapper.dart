import 'package:danger_zone_alert/auth/screens/welcome.dart';
import 'package:danger_zone_alert/shared/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/application_bloc.dart';
import 'google_map/screens/google_map.dart';
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

    return user == null
        ? const WelcomeScreen()
        : Consumer<ApplicationBloc>(
            builder: (context, provider, child) => (provider.position == null)
                ? const Loading()
                : (provider.position is String)
                    ? const GoogleMapScreen()
                    : GoogleMapScreen(position: provider.position),
          );
  }
}
