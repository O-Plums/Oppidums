import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CityModel extends ChangeNotifier {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _id;
  String _name;
  String _url;

  String get id => _id;
  String get name => _name;
  String get url => _url;


  void setCityBasicInfo(String id, String url, String name) {
    _id = id;
    _name = name;
    _url = url;
    notifyListeners();
  }

}
