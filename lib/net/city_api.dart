import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart';

class CarcassonneCityApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<List<dynamic>> getAllCity() async {
    var res = await _client.get('cities');
  final parsed = jsonDecode(res.data).cast<Map<String, dynamic>>();

  return parsed.map<dynamic>((json) => json).toList();
  }

}
