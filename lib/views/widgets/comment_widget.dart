import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_flat_button.dart';
import 'package:oppidum/views/widgets/input_text.dart';
import 'package:oppidum/net/comment_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CommentWidget extends StatefulWidget {
  final Function onValidate;
  final String placeId;

  CommentWidget({
    Key key,
    this.placeId,
    this.onValidate,
  }) : super(key: key);

  @override
  _CommentWidget createState() => _CommentWidget();
}

class _CommentWidget extends State<CommentWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _title;
  String _description;

  void _handleChange(String type, String value) {
    if (type == 'title') {
      setState(() {
        _title = value;
      });
    }

    if (type == 'description') {
      setState(() {
        _description = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff101519),
        height: 550,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(FlutterI18n.translate(context, "common.common_word.comment"),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 20, bottom: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: InputText(
              placeholder: FlutterI18n.translate(context, "common.create_meeting.placeholderTitle"),
              border: false,
              onChange: (value) => _handleChange('title', value),
            ),
          ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: InputText(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              placeholder: FlutterI18n.translate(context, "common.common_word.placeholderComment"),
              border: false,
              onChange: (value) => _handleChange('description', value),
            ),
          ),
          CustomFlatButton(
            label: FlutterI18n.translate(context, "common.add_city_widget.buttonSend"),
            color: Color(0xfff6ac65),
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;

              final token = prefs.getString('googlePYMP');

              Map<String, dynamic> payload = JwtDecoder.decode(token);
              Navigator.pop(context);
              var newComment = await OppidumCommentApi.createComment(
                  _title, _description, widget.placeId, payload['_id']);
              widget.onValidate(newComment);
            },
            width: 300,
          ),
        ])));
  }
}
