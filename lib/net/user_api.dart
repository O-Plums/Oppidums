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
  
  static Future<Map<String, dynamic>> appleSignIn(var credential) async {
  
      var res = await _client.post('service/User/incoming_webhook/iosLogin',
        data: {
          "authorizationCode": credential.authorizationCode,
          "user": credential.userIdentifier,
          "fullName": {
            "givenName": credential.givenName,
            "familyName": credential.familyName
          },
    });
    return res.data;
  }

}
