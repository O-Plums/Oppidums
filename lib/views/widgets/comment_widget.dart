import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_flat_button.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:carcassonne/views/widgets/input_text.dart';

class CommentWidget extends StatefulWidget {
  final Function onValidate;

  CommentWidget({
    Key key,
    this.onValidate,
  }) : super(key: key);

  @override
  _CommentWidget createState() => _CommentWidget();
}

class _CommentWidget extends State<CommentWidget> {
  void _handleChange(String type, String value) {
    print('$type $value');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 500,
        child: SingleChildScrollView(
            child: Column(children: [
                  Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Ajouter un commentaire',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 20, bottom: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: InputText(
              placeholder: 'Titre',
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
              placeholder: 'Commentaire',
              border: false,
              onChange: (value) => _handleChange('comment', value),
              
            ),
          ),
          CustomFlatButton(
            label: 'Envoyer',
            color: Color(0xffab9bd9),
            onPressed: () {
              Navigator.pop(context);
              widget.onValidate();

            },
            width: 300,
          ),
        ])));
  }
}
