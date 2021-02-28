import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carcassonne/router.dart';

import 'package:carcassonne/views/widgets/loading_widget.dart';


class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    //Check local storage for token if user already connect
    new Future.delayed(Duration.zero, () async {
          AppRouter.router.navigateTo(context, 'city', replace: true);

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingAnnimation()
    );
  }
}
