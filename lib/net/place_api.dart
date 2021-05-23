import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';

class CarcassonnePlaceApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<List<dynamic>> getPlaceByType(
      String type, String cityId) async {
    var res = await _client.get(
      'places',

      // 'service/GetPlaces/incoming_webhook/webhook0',
      queryParameters: {"type": type, "city": cityId},
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> getPlaceById(String placeId) async {
    var res = await _client.get('places/$placeId'
        // 'service/GetOnePlace/incoming_webhook/webhook0',
        // queryParameters: {"placeId": placeId},
        );
    return res.data;
  }
}

