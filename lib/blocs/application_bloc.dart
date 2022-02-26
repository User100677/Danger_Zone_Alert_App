import 'package:danger_zone_alert/services/geolocator_service.dart';
import 'package:danger_zone_alert/shared/widgets/error_snackbar.dart';
import 'package:flutter/cupertino.dart';

class ApplicationBloc with ChangeNotifier {
  late final GeolocatorService _geolocatorService;
  late dynamic context;

  dynamic _position;

  set position(position) {
    _position = position;
    notifyListeners();
  }

  ApplicationBloc(this.context) {
    _geolocatorService = GeolocatorService();
    loadPosition(context);
  }

  Future<void> loadPosition(context) async {
    position =
        await _geolocatorService.getInitialLocation(context).catchError((e) {
      errorSnackBar(context, e);
      position = e;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic get position => _position;
}
