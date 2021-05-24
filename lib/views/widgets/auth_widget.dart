import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/google_login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carcassonne/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/router.dart';

class AuthWidget extends StatefulWidget {
  final Function onValidate;

  AuthWidget({
    Key key,
    this.onValidate,
  }) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = false;

  void _handleLogin(context, Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await _prefs;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var userModel = Provider.of<UserModel>(context, listen: false);
      userModel.auth(userData['token']);
      prefs.setString('googlePYMP', userData['token']);
      await userModel.populate(userData);
      widget.onValidate();
      AppRouter.router.pop(context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      prefs.remove('googlePYMP');
      print(error);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff101519),
        height: 100,
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Text('Connexion',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          if (!isLoading)
            GoogleLoginButton(
                onLogin: (Map<String, dynamic> userData) =>
                    _handleLogin(context, userData)),
          if (isLoading)
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEA178C)))
        ])));
  }
}
