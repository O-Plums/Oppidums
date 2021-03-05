// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:jim/net/jim/social_auth_api.dart';
// // import 'package:jim/views/widgets/amplitude_flat_button.dart';
// import 'dart:io';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//   ],
// );

// class GoogleLoginButton extends StatelessWidget {
//   final Function(String accessToken) onLogin;

//   GoogleLoginButton({this.onLogin});

//   Future<void> _handleSignIn(context) async {
//     try {
//       var res = await _googleSignIn.signIn();
//       if (res != null) {
//         var authInstance = await res.authentication;
//         final lng = Localizations.localeOf(context).languageCode;
//         final plateforme = Platform.operatingSystem;
//         // var jimToken =
//         // await JimSocialAuthApi.googleSignIn(authInstance.accessToken, plateforme, lng);
//         if (onLogin != null) {
//           // onLogin(jimToken);
//         }
//       }
//     } catch (error) {
//       _showDialog(context, error);
//       print(error);
//     }
//   }

//   void _showDialog(context, error) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Error GOOGLE"),
//           content: Text("Error => $error"),
//           actions: [
//             FlatButton(
//               child: Text("OK"),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//       Container(
//         width: 300,
//         height: 36,
//         margin: EdgeInsets.only(top: 5, bottom: 5),
//         child: AmplitudeFlatButton(
//             eventName: 'Action_google_login',
//             color: Colors.black,
//             onPressed: () => _handleSignIn(context),
//             width: 300,
//             label: FlutterI18n.translate(context, "common.LoginGoogle.buttonTitle")
//         ),
//       );
//   }
// }
