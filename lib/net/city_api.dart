import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';

class CarcassonneCityApi {
  static Dio _client = createCarcassonneDioClient();

  static Future<List<dynamic>> getAllCity(String searchName) async {
    var res = await _client.get('cities',
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
    print(res.data);
    return res.data;
  }
}
