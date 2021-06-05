import 'package:dio/dio.dart';
import 'package:oppidum/net/client.dart';

class OppidumMeetApi {
  static Dio _client = createOppidumDioClient();

  static Future<List<dynamic>> getMeetCity(String cityId) async {
    var res = await _client.get(
      'meets',
      queryParameters: {"city": cityId},
    );
    return res.data;
  }

    static Future<List<dynamic>> getOwnerMeet(String owner) async {
    var res = await _client.get(
      'meets',
/*TODO maibe add city id */

      queryParameters: {"owner": owner},
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
    static Future<Map<String, dynamic>> deleteMeetById(String meetsId) async {
    var res = await _client.delete('meets/$meetsId'
        );
    return res.data;
  }

  static Future<Map<String, dynamic>> createMeet(
    String userId,
    String cityId,
    String placeId,
    String title,
    String description,
    DateTime startDate,
  ) async {

    var res = await _client.post('meets', data: {
      'owner': userId,
      'place': placeId,
      'city': cityId,
      'title': title,
      'description': description,
      'startDate': startDate.toString()
    });
    return res.data;
  }

  static Future<Map<String, dynamic>>  joinMeet(String meetId, List<dynamic> participens) async {
    var res = await _client.put(
      'meets/${meetId}',
      data: {"participens": participens},
    );
    return res.data;
  }

  
}
