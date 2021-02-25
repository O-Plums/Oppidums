import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:carcassonne/views/home/home_view.dart';
import 'package:carcassonne/views/splash/splash_view.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  static Handler _splashHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        FirebaseAnalytics().setCurrentScreen(screenName: context.settings.name);
        return SplashView();
      }
  );

  static void setupRouter() {
    router.define('splash', handler: _splashHandler);
 

  }
}
