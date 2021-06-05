import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppidum/router.dart';
import 'package:oppidum/models/city_model.dart';
import 'package:provider/provider.dart';
import 'package:oppidum/views/widgets/loading_widget.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //TODO populate le user  pour les prefs
  @override
  void initState() {
    super.initState();
    //Check local storage for token if user already connect
    new Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await _prefs;
      final String cityId = prefs.getString('cityId');
      final String cityUrl = prefs.getString('cityUrl');
      final String cityName = prefs.getString('cityName');
      if (cityId != null && cityId != '') {
        var cityModel = Provider.of<CityModel>(context, listen: false);
        cityModel.setCityBasicInfo(cityId, cityUrl, cityName);
        AppRouter.router.navigateTo(context, 'home', replace: true);
      } else {
        AppRouter.router.navigateTo(context, 'city', replace: true);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff101519), body: LoadingAnnimation());
  }
}
