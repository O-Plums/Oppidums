import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart';

class CarcassonneCityApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<List<dynamic>> getAllCity() async {
    var res = await _client.get('cities');
    return res.data;
  }

  static Future<Map<String, dynamic>> getCitieById(String citiesId) async {
    var res = await _client.get('cities/$citiesId'
        // 'service/GetOnePlace/incoming_webhook/webhook0',
        // queryParameters: {"placeId": placeId},
        );
    return res.data;
  }

  static Future<List<dynamic>> getEventOfCitie(String citiesId) async {
    var res = await _client.get(
      'events',

      // 'service/GetOnePlace/incoming_webhook/webhook0',
      queryParameters: {"city": citiesId},
    );
    print(res.data);
    return res.data;
  }
}
