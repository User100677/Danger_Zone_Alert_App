import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:flutter/cupertino.dart';

class ApplicationBloc with ChangeNotifier {
  late dynamic context;

  dynamic _position;

  set position(position) {
    _position = position;
    notifyListeners();
  }

  ApplicationBloc(this.context) {
    loadPosition(context);
  }

  Future<void> loadPosition(context) async {
    position =
        await GeolocatorService.getInitialLocation(context).catchError((e) {
      errorSnackBar(context, e);
      position = e;
    });
  }

  dynamic get position => _position;
}
