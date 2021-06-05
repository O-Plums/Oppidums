import 'package:dio/dio.dart';
import 'package:oppidum/net/client.dart';

class OppidumPlaceApi {
  static Dio _client = createOppidumDioClient();


  static Future<List<dynamic>> getAllPlaceOfCity(
     String cityId) async {
    var res = await _client.get(
      'places',

      // 'service/GetPlaces/incoming_webhook/webhook0',
      queryParameters: {"city": cityId},
    );
    return res.data;
  }

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

   static Future<Map<String, dynamic>> updateApproval(String placeId, List<dynamic> approval) async {
    var res = await _client.put('places/$placeId', data: {
      "approval": approval,
    });

    return res.data;
  }
}

