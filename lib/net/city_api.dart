import 'package:dio/dio.dart';
import 'package:oppidums/net/client.dart';

class OppidumsCityApi {
  static Dio _client = createOppidumsDioClient();

  static Future<List<dynamic>> getAllCity(String searchName) async {
    var res = await _client.get(
      'cities',
      queryParameters: {"_q": searchName},
    );
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
    return res.data;
  }

  static Future<List<dynamic>> requestNewCity(String cityName, String cityRole, String email) async {
    var res = await _client.post(
      'ask-contacts',
      data: {
        "cityName": cityName,
        "cityRole": cityRole,
        "email": email,
      },
    );
    return res.data;
  }
}
