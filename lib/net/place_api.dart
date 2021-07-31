import 'package:dio/dio.dart';
import 'package:oppidum/net/client.dart';
import 'dart:math';

List shuffle(List items) {
  var random = new Random();

  for (var i = items.length - 1; i > 0; i--) {

    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

class OppidumPlaceApi {
  static Dio _client = createOppidumDioClient();

  static Future<List<dynamic>> getAllPlaceOfCity(
     String cityId) async {
    var res = await _client.get(
      'places',
      queryParameters: {"city": cityId},
    );
    return shuffle(res.data);
  }

  static Future<List<dynamic>> getPlaceByType(
      String type, String cityId) async {
    
    var res = await _client.get(
      'places',
      queryParameters: {"type": type, "city": cityId},
    );
    
    return res.data;
  }

  static Future<Map<String, dynamic>> getPlaceById(String placeId) async {
    var res = await _client.get('places/$placeId'
        // queryParameters: {"placeId": placeId},
        );
    return res.data;
  }

   static Future<Map<String, dynamic>> updateApproval(String placeId, List<dynamic> approval, String accessToken) async {
    var res = await _client.put('places/$placeId', data: {
      "approval": approval,
    },
    options: Options(headers: {'x-access-token': accessToken}));

    return res.data;
  }
}

