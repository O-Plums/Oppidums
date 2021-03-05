import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_flat_button.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:carcassonne/views/widgets/input_text.dart';

class AddCityWidget extends StatefulWidget {
  final Function onValidate;

  AddCityWidget({
    Key key,
    this.onValidate,
  }) : super(key: key);

  @override
  _AddCityWidgetState createState() => _AddCityWidgetState();
}

class _AddCityWidgetState extends State<AddCityWidget> {
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
                    'Formulaire de contacte',
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
              placeholder: 'Nom de la ville',
              border: false,
              onChange: (value) => _handleChange('cityName', value),
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
              placeholder: 'Role dans la ville',
              border: false,
              onChange: (value) => _handleChange('cityJob', value),
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
              placeholder: 'Email de contacte',
              border: false,
              onChange: (value) => _handleChange('contactEmail', value),
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
