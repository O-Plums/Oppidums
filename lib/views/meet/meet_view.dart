import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/meet_card.dart';
import 'package:oppidum/views/meet/widgets/create_meeting.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/widgets/loading_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:oppidum/models/city_model.dart';
import 'package:oppidum/net/meet_api.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidum/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class MeetView extends StatefulWidget {
  final String id;
  final String placeId;

  MeetView({Key key, this.id, this.placeId}) : super(key: key);

  @override
  _MeetView createState() => _MeetView();
}

class _MeetView extends State<MeetView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool loading = false;
  int _currentSelection = 0;
  List<dynamic> _meets = [];
  List<dynamic> _ownerMeets = [];

  void fetchMeet(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');
    Map<String, dynamic> payload = JwtDecoder.decode(token);

    var cityModel = Provider.of<CityModel>(context, listen: false);
    var meets = await OppidumMeetApi.getMeetCity(cityModel.id);
    var ownerMeets = await OppidumMeetApi.getOwnerMeet(payload['_id']);
    if (mounted) {
      setState(() {
        _ownerMeets = ownerMeets;
        _meets = meets;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      await fetchMeet(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
          backgroundColor: Color(0xff101519),
          appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.meet_view.titlePageVisit")),
          body: LoadingAnnimation());
    }

    return Scaffold(
        backgroundColor: Color(0xff101519),
        appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.meet_view.titlePageVisit")),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                margin: EdgeInsets.only(top: 20),
              ),
              MaterialSegmentedControl(
                children: {
                  0: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text(FlutterI18n.translate(context, "common.meet_view.titlePageVisit"),
                          style: TextStyle(fontSize: 12, color: Colors.black))),
                  1: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text(FlutterI18n.translate(context, "common.meet_view.textMyVisite"),
                          style: TextStyle(fontSize: 12, color: Colors.black))),
                  2: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text(FlutterI18n.translate(context, "common.meet_view.newVisite"),
                          style: TextStyle(fontSize: 12, color: Colors.black)))
                },
                selectionIndex: _currentSelection,
                borderColor: Colors.grey,
                selectedColor: Color(0xfff6ac65),
                unselectedColor: Colors.white,
                borderRadius: 11.0,
                disabledChildren: [3],
                onSegmentChosen: (index) {
                  setState(() {
                    _currentSelection = index;
                  });
                },
              ),
                  if (_currentSelection == 0 && _meets.length == 0 && loading == false) Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 50),
          child: Text(FlutterI18n.translate(context, "common.common_word.noData"),  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18))),
              if (_currentSelection == 0)
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(children: [
                      ..._meets.map((meet) {
                        return MeetCard(
                            isDelPossible: false,
                            meet: meet,
                            onPressed: () {
                              AppRouter.router.navigateTo(
                                context,
                                'meet/one',
                                replace: false,
                                transition: TransitionType.inFromRight,
                                routeSettings: RouteSettings(arguments: {
                                  'meetId': meet['_id'],
                                }),
                              );
                            });
                      }).toList()
                    ])),
                      if (_currentSelection == 1 && _ownerMeets.length == 0 && loading == false) Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 50),
          child: Text(FlutterI18n.translate(context, "common.common_word.noData"),  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18))),
              if (_currentSelection == 1)
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(children: [
                      ..._ownerMeets.map((meet) {
                        return MeetCard(
                            isDelPossible: true,
                            fetchMeet: () {
                              fetchMeet(context);
                            },
                            meet: meet,
                            onPressed: () {
                              AppRouter.router.navigateTo(
                                context,
                                'meet/one',
                                replace: false,
                                transition: TransitionType.inFromRight,
                                routeSettings: RouteSettings(arguments: {
                                  'meetId': meet['_id'],
                                }),
                              );
                            });
                      }).toList()
                    ])),
              if (_currentSelection == 2)
                Container(
                    margin: EdgeInsets.all(20),
                    child: CreatingMeetingView(
                      onCreate: () {
                        setState(() {
                          _currentSelection = 0;
                        });
                        fetchMeet(context);
                      },
                    ))
            ])));
  }
}
