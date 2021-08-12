import 'package:dio/dio.dart';
import 'package:oppidums/app_config.dart';

Dio createOppidumsRealmDioClient([BaseOptions options]) {
  Dio client = new Dio();
  client.options.baseUrl = AppConfig.realmUrl;
  client.options.headers = {
    'x-speed-string': 'New_spped_string',
    'x-api-version': AppConfig.apiVersion,
  };
  return client;
}
