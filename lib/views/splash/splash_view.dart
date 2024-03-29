import 'package:flutter/material.dart';
import 'package:oppidums/net/city_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppidums/router.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:provider/provider.dart';
import 'package:oppidums/views/widgets/loading_widget.dart';
import 'package:uni_links/uni_links.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidums/models/user_model.dart';
import 'package:oppidums/analytics.dart';

import 'package:oppidums/net/user_api.dart';

import 'dart:async';
import 'dart:io';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  StreamSubscription _sub;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> initUniLinks(Uri uri) async {
    // _sub = getUriLinksStream().listen((Uri uri) async {
    var splitUri = uri.toString().split('//')[1].split('/');

    final SharedPreferences prefs = await _prefs;
    final city = await OppidumsCityApi.getCitieById(splitUri[1]);
    prefs.setString('cityId', city['_id']);
    prefs.setString('cityUrl', city['image']['url']);
    prefs.setString('cityName', city['name']);
    var cityModel = Provider.of<CityModel>(context, listen: false);
    cityModel.setCityBasicInfo(city['_id'], city['image']['url'], city['name']);

    if (splitUri.length >= 2) {
      AppRouter.router.navigateTo(context, 'home', replace: true, transition: TransitionType.inFromRight);

      AppRouter.router.navigateTo(
        context,
        'place',
        replace: false,
        transition: TransitionType.inFromRight,
        routeSettings: RouteSettings(arguments: {
          'placeId': splitUri[2],
        }),
      );
      return;
    }
    if (splitUri.length >= 1) {
      AppRouter.router.navigateTo(context, 'home', replace: true, transition: TransitionType.inFromRight);
    }
    // });
  }

  void _checkLocalStorage(context) async {
    var userModel = Provider.of<UserModel>(context, listen: false);
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');

    if (token != null) {
      try {
        Map<String, dynamic> userData = await OppidumsUserApi.populateUser(token);
        if (userData['token'] != '') {
          userModel.auth(userData['token']);
          prefs.setString('googlePYMP', userData['token']);
          await userModel.populate(userData);
          OppidumsAnalytics.analytics.setUserId(userModel.id);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //Check local storage for token if user already connect
    new Future.delayed(Duration.zero, () async {
      await _checkLocalStorage(context);
      Uri initialUri = await getInitialUri();
      if (initialUri == null) {
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
      } else {
        initUniLinks(initialUri);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xff101519), body: LoadingAnnimation());
  }
}
