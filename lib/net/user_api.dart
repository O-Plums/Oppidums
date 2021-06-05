import 'package:dio/dio.dart';
import 'package:oppidum/net/realm_client.dart';

class OppidumUserApi {
  static Dio _client = createOppidumRealmDioClient();

  static Future<Map<String, dynamic>> googleSignIn(String accessToken) async {
    var res = await _client.get(
      'service/User/incoming_webhook/googleLogin',
      queryParameters: {"accessToken": accessToken},
      // data: data,
    );
    return res.data;
  }

}
