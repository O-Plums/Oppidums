import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:oppidum/app_config.dart';

Dio createOppidumRealmDioClient([BaseOptions options]) {
  Dio client = new Dio();
  client.options.baseUrl = AppConfig.realmUrl;
  client.options.headers = {
    'x-speed-string': 'New_spped_string',
    'x-api-version': AppConfig.apiVersion,
  };
  client.transformer = FlutterTransformer();
  return client;
}
