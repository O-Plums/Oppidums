import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/google_login_button.dart';
import 'package:oppidums/views/widgets/apple_login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppidums/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidums/router.dart';
import 'package:oppidums/analytics.dart';

import 'dart:io';

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
      OppidumsAnalytics.analytics.setUserId(userModel.id);
      widget.onValidate();
      AppRouter.router.pop(context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      prefs.remove('googlePYMP');
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
        height: Platform.isIOS || Platform.isMacOS ? 150 : 100,
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(FlutterI18n.translate(context, "common.common_word.connect"),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          if (!isLoading)
            GoogleLoginButton(onLogin: (Map<String, dynamic> userData) => _handleLogin(context, userData)),
          if (!isLoading && (Platform.isIOS || Platform.isMacOS))
            AppleLoginButton(onLogin: (Map<String, dynamic> userData) => _handleLogin(context, userData)),
          if (isLoading) CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEA178C)))
        ])));
  }
}
