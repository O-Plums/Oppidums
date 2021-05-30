import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';
import 'package:carcassonne/models/city_model.dart';
import 'package:carcassonne/net/place_api.dart';
import 'package:carcassonne/views/widgets/simple_select.dart';
import 'package:carcassonne/views/widgets/input_text.dart';
import 'package:carcassonne/views/widgets/app_flat_button.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:carcassonne/net/meet_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:carcassonne/views/widgets/loading_widget.dart';


class CreatingMeetingView extends StatefulWidget {
  final Function onCreate;

  CreatingMeetingView({Key key, this.onCreate}) : super(key: key);

  @override
  _CreatingMeetingView createState() => _CreatingMeetingView();
}

class _CreatingMeetingView extends State<CreatingMeetingView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool loading = false;
  bool loadingButton = false;
  List<S2Choice<String>> _places = [];
  DateTime _startDate;
  String _title;
  String _description;
  String _placeSeleced;

  void _onValidate(context) async {
    if (mounted) {
      setState(() {
        loadingButton = true;
      });
    }

    var cityModel = Provider.of<CityModel>(context, listen: false);

    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');
    Map<String, dynamic> payload = JwtDecoder.decode(token);
    await CarcassonneMeetApi.createMeet(
      payload['_id'],
      cityModel.id,
      _placeSeleced,
      _title,
      _description,
      _startDate,
    );
    if (mounted) {
      setState(() {
        loadingButton = false;
      });
    }
    widget.onCreate();
  }

  void fetchPlace(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    var cityModel = Provider.of<CityModel>(context, listen: false);
    var places = await CarcassonnePlaceApi.getAllPlaceOfCity(cityModel.id);

    List<S2Choice<String>> test = [];

    for (var place in places) {
      test.add(S2Choice<String>(title: place['name'], value: place['_id']));
    }

    if (mounted) {
      setState(() {
        _places = test;
        loading = false;
      });
    }
  }

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
    if (type == 'place') {
      setState(() {
        _placeSeleced = value;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      await fetchPlace(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
        if (loading == true) {
      return Center(
          child: LoadingAnnimation());
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
          ),
          Container(
            child: SimpleSelect(
              label: 'Choissier un lieux',
              title: 'Lieux a visiter',
              list: _places,
              onChange: (value) => _handleChange('place', value),
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(), onChanged: (date) {
                      setState(() {
                        _startDate = date;
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        _startDate = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.fr);
                  },
                  child: Text(
                    _startDate == null
                        ? 'Choissier une date pour la visite'
                        : (DateFormat('hh:mm -  dd-MM-yyyy')
                            .format(_startDate)),
                    style: TextStyle(color: Colors.white),
                  ))),
          Container(
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
            margin: EdgeInsets.only(top: 20, bottom: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            child: InputText(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              placeholder: 'Description',
              border: false,
              onChange: (value) => _handleChange('description', value),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: CustomFlatButton(
              disabledColor: Colors.grey,
              label: 'Envoyer',
              loading: loadingButton,
              textColor: Colors.black,
              color: Colors.white,
              onPressed: () {
                if (_title != '' &&
                    _description != '' &&
                    _startDate != null &&
                    _placeSeleced != '') {
                  // Navigator.pop(context);
                  _onValidate(context);
                }
              },
              width: 300,
            ),
          ),
        ]);
  }
}
