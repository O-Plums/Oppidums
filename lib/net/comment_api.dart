import 'package:dio/dio.dart';
import 'package:oppidum/net/client.dart';

class OppidumCommentApi {
  static Dio _client = createOppidumDioClient();

  static Future<Map<String,dynamic>> createComment(
      String title, String description, String placeId, String userId) async {
    var res = await _client.post('comments', data: {
      'title': title,
      'description': description,
      'place': placeId,
      'app_user': userId
    });
    return res.data;
  }

static Future<List<dynamic>> getCommentByPlace(String placeId) async {
  var res = await _client.get('comments',
      queryParameters: {
        "place": placeId,
      "_sort": "createdAt:DESC"
      },
      );
  return res.data;
}

    static Future<Map<String, dynamic>> deleteCommentById(String commentId) async {
    var res = await _client.delete('comments/$commentId'
        );
    return res.data;
  }
}
