import 'package:dio/dio.dart';
import 'package:carcassonne/net/jim/client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart';

class JimUserApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<Map<String, dynamic>> getAllCity() async {
    return null;
  }
}
