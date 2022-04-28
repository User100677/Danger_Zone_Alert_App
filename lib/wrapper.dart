import 'package:danger_zone_alert/auth/screens/authenticate.dart';
import 'package:danger_zone_alert/intermediary_screen.dart';
import 'package:danger_zone_alert/shared/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'map/utilities/application_bloc.dart';
import 'models/user.dart';

/*
   This widget loads HomeScreen or IntermediaryScreen
   depending on the authentication of the user.
*/

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assign userModel after log in
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return Consumer<ApplicationBloc>(
          builder: (context, provider, child) => (provider.position == null)
              ? const Loading()
              : (provider.position is String)
                  ? IntermediaryScreen(user: user)
                  : IntermediaryScreen(
                      user: user, userPosition: provider.position));
    }
  }
}
