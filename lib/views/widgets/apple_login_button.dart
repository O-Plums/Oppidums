import 'package:flutter/material.dart';
import 'package:oppidums/net/user_api.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

class AppleLoginButton extends StatelessWidget {
  final Function onLogin;

  AppleLoginButton({Key key, this.onLogin}) : super(key: key);

  void _handleSignIn(context) async {
    try {

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      var token = await OppidumsUserApi.appleSignIn(credential);
      if (onLogin != null) {
        onLogin(token);
      }
    } catch (error) {
      _showDialog(context, error);

      return;
    }
  }

  void _showDialog(context, error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error GOOGLE"),
          content: Text("Error => $error"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 36,
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: SignInWithAppleButton(
        onPressed: () => _handleSignIn(context),
      ),
    );
  }
}
