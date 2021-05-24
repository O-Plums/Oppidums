import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';

class CarcassonneMeetApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<List<dynamic>> getMeetCity(String cityId) async {
    var res = await _client.get('meets',
        queryParameters: { "city": cityId },
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> getMeetById(String meetsId) async {
    var res = await _client.get('meets/$meetsId'
        // 'service/GetOnePlace/incoming_webhook/webhook0',
        // queryParameters: {"placeId": placeId},
        );
    return res.data;
  }

  // static Future<List<dynamic>> createMeet(String citiesId) async {
  //   var res = await _client.get(
  //     'events',

  //     // 'service/GetOnePlace/incoming_webhook/webhook0',
  //     queryParameters: {"city": citiesId},
  //   );
  //   print(res.data);
  //   return res.data;
  // }
}
