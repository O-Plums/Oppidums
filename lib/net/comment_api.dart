import 'package:dio/dio.dart';
import 'package:carcassonne/net/client.dart';

class CarcassonneCommentApi {
  static Dio _client = createCarcassonneDioClient();

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
}
