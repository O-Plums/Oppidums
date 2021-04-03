import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _id;
  String _name;
  String _email;
  String _picture;
  String _accessToken;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get picture => _picture;
  bool get isAuthed => _accessToken != null;


  void updateProfile(Map<String, dynamic> userData) {
    _id = userData['id'];
    notifyListeners();
  }
  
  void auth(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }

   populate(Map<String, dynamic> userData) async {
    // final SharedPreferences prefs = await _prefs;

    _id = userData['_id'];
    _name = userData['lastName'];
    _email = userData['completeName'];
    _picture = userData['picture'];

    notifyListeners();
  }

}
