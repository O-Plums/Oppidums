import 'package:dio/dio.dart';
import 'package:oppidums/net/client.dart';

class OppidumsUserApi {
  static Dio _clientStrapi = createOppidumsDioClient();

  static Future<Map<String, dynamic>> googleSignIn(String accessToken) async {
    var res = await _clientStrapi.post(
      'app-users/google/login',
      queryParameters: {"accessToken": accessToken},
      // data: data,
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> appleSignIn(var credential) async {
    var res = await _clientStrapi.post('app-users/ios/login', data: {
      "authorizationCode": credential.authorizationCode,
      "user": credential.userIdentifier,
      "fullName": {"givenName": credential.givenName, "familyName": credential.familyName},
    });
    return res.data;
  }

  static Future<Map<String, dynamic>> populateUser(String accessToken) async {
    var res = await _clientStrapi.get('app-users/populate', options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }
}
