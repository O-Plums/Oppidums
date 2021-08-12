import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oppidums/views/widgets/app_flat_button.dart';
import 'package:oppidums/net/user_api.dart';
import 'package:oppidums/views/widgets/app_inkwell.dart';

// import 'package:jim/net/jim/social_auth_api.dart';
// import 'package:jim/views/widgets/amplitude_flat_button.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class GoogleLoginButton extends StatelessWidget {
  final Function(Map<String, dynamic> userData) onLogin;

  GoogleLoginButton({this.onLogin});

  Future<void> _handleSignIn(context) async {
    try {
      var res = await _googleSignIn.signIn();
      if (res != null) {
        var authInstance = await res.authentication;

        Map<String, dynamic> userData =
            await OppidumsUserApi.googleSignIn(authInstance.accessToken);
        onLogin(userData);
      }
    } catch (error) {
      _showDialog(context, error);
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
            TextButton(
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
      child:   CustomInkWell(
        eventName: 'google_login_button',
        onTap: () async { _handleSignIn(context); },
       child:  Container(
       decoration: BoxDecoration(color: Color(0xFF397AF3), borderRadius: BorderRadius.circular(5)),
      width: 300,
    child: Padding(
      padding: EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [
          Image.asset('assets/google-logo.webp', width: 30), // <-- Use 'Image.asset(...)' here
          // SizedBox(width: 12),
          Text('Sign in with Google', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    ),
  ), 
                          ),
    );
  }
}

  
