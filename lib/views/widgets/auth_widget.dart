import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_flat_button.dart';
import 'package:carcassonne/views/widgets/input_text.dart';

class AuthWidget extends StatefulWidget {
  final Function onValidate;

  AuthWidget({
    Key key,
    this.onValidate,
  }) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  void _handleChange(String type, String value) {
    print('$type $value');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 200,
        child: SingleChildScrollView(
            child: Column(children: [
                  Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Formulaire de contacte',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
          CustomFlatButton(
            label: 'Google login',
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
