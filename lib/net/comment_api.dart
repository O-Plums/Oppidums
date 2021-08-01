import 'package:dio/dio.dart';
import 'package:oppidums/net/client.dart';

class OppidumsCommentApi {
  static Dio _client = createOppidumsDioClient();

  static Future<Map<String, dynamic>> createComment(String accessToken,
      String title, String description, String placeId, String userId) async {
    var res = await _client.post('comments',
        data: {
          'title': title,
          'description': description,
          'place': placeId,
          'app_user': userId
        },
        options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }

  static Future<List<dynamic>> getCommentByPlace(String placeId) async {
    var res = await _client.get(
      'comments',
      queryParameters: {"place": placeId, "_sort": "createdAt:DESC"},
    );
    return res.data;
  }

  static Future<Map<String, dynamic>> deleteCommentById(
      String commentId, String accessToken) async {
    var res = await _client.delete('comments/$commentId',
        options: Options(headers: {'x-access-token': accessToken}));
    return res.data;
  }
}
