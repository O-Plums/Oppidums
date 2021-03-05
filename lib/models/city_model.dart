import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CityModel extends ChangeNotifier {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _id;

  String get id => _id;


  void setCityId(String id) {
    _id = id;
    notifyListeners();
  }

}
