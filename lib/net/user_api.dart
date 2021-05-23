import 'package:dio/dio.dart';
import 'package:carcassonne/net/realm_client.dart';

class CarcassonneUserApi {
  static Dio _client = createCarcassonneRealmDioClient();

  static Future<Map<String, dynamic>> googleSignIn(String accessToken) async {
    var res = await _client.get(
      'service/User/incoming_webhook/googleLogin',
      queryParameters: {
        "accessToken": accessToken
      },
      // data: data,
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> updateApproval(String userId, String placeId)  async {

      var res = await _client.put(
      '/service/User/incoming_webhook/updateApproval',
      queryParameters: {
        "userId": userId,
        "placeId": placeId,
      },
    );
    return res.data;

  }
}
