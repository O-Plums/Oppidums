import 'package:dio/dio.dart';
import 'package:oppidums/net/client.dart';

class OppidumsMeetApi {
  static Dio _client = createOppidumsDioClient();

  static Future<List<dynamic>> getMeetCity(String cityId) async {
    var res = await _client.get(
      'meets',
      queryParameters: {"city": cityId},
    );
    return res.data;
  }

  static Future<List<dynamic>> getOwnerMeet(String owner, String accessToken) async {
    var res = await _client.get('meets',
        queryParameters: {"owner": owner}, options: Options(headers: {'x-access-token': accessToken}));

    return res.data;
  }

  static Future<Map<String, dynamic>> getMeetById(String meetsId, String accessToken) async {
    var res = await _client.get('meets/$meetsId', options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }

  static Future<Map<String, dynamic>> deleteMeetById(String meetsId, String accessToken) async {
    var res = await _client.delete('meets/$meetsId', options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }

  static Future<Map<String, dynamic>> createMeet(
    String userId,
    String cityId,
    String placeId,
    String title,
    String description,
    DateTime startDate,
    String accessToken,
  ) async {
    var res = await _client.post('meets',
        data: {
          'owner': userId,
          'place': placeId,
          'city': cityId,
          'title': title,
          'description': description,
          'startDate': startDate.toString()
        },
        options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }

  static Future<Map<String, dynamic>> joinMeet(String meetId, List<dynamic> participens, String accessToken) async {
    var res = await _client.put('meets/${meetId}',
        data: {"participens": participens}, options: Options(headers: {'x-access-token': accessToken}));

    return res.data;
  }
}
