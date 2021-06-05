import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_flat_button.dart';
import 'package:oppidum/views/widgets/app_inkwell.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidum/views/widgets/input_text.dart';
import 'package:oppidum/net/city_api.dart';

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
  String cityName;
  String cityRole;
  String email;

  void _handleChange(String type, String value) {
    if (type == 'cityName') {
      setState(() {
              cityName = value;
            });
    }

     if (type == 'cityRole') {
      setState(() {
              cityRole = value;
            });
    }

     if (type == 'email') {
      setState(() {
              email = value;
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        color: Color(0xff101519),
        height: 500,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(children: [
                  Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    FlutterI18n.translate(context, "common.add_city_widget.contactForm"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
          Container(
            width: 300,
            margin: EdgeInsets.only(top: 20, bottom: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: InputText(
              placeholder: FlutterI18n.translate(context, "common.add_city_widget.placeHolderNameCity"),
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
              placeholder: FlutterI18n.translate(context, "common.add_city_widget.placeHolderRoleCity"),
              border: false,
              onChange: (value) => _handleChange('cityRole', value),
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
              placeholder: FlutterI18n.translate(context, "common.add_city_widget.placeHolderEmail"),
              border: false,
              onChange: (value) => _handleChange('email', value),
            ),
          ),
          CustomFlatButton(
            label: FlutterI18n.translate(context, "common.add_city_widget.buttonSend"),
            textColor: Colors.black,
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              OppidumCityApi.requestNewCity(
              cityName,
              cityRole,
              email
              );

              widget.onValidate();
            },
            width: 300,
          ),
        ])));
  }
}
