import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _id;

  String get id => _id;


  void updateProfile(Map<String, dynamic> userData) {
    _id = userData['id'];
    notifyListeners();
  }

}
