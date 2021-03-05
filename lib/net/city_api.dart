import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart';

class CarcassonneCityApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<Map<String, dynamic>> getAllCity() async {
    var res = await _client.get('service/GetCities/incoming_webhook/webhook0');
    return res.data;
  }
}
