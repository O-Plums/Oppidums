import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static String appVersion;
  static String env;
  static String apiUrl;
  static String apiVersion;
  static String sentryDns;

  static Future<void> load(String e) async {
    env = e ?? 'dev';
    final contents = await rootBundle.loadString(
      'config/$env.json',
    );

    final json = jsonDecode(contents);
    appVersion = json['appVersion'];
    apiUrl = json['apiUrl'];
    apiVersion = json['apiVersion'];
    sentryDns = json['sentry']['dns'];
  }
}
