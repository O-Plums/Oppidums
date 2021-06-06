import 'package:flutter/material.dart';
import 'package:oppidum/net/user_api.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

//TODO NEED TO BE FINISH
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
      final lng = Localizations.localeOf(context).languageCode;
      final plateforme = Platform.operatingSystem;
      var token =
          await OppidumUserApi.appleSignIn(credential);
      // if (onLogin != null) {
      //   onLogin(token);
      // }
    } catch (e) {
      return;
    }
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
