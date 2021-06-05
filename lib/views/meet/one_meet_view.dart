import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:oppidum/views/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppidum/net/user_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oppidum/net/meet_api.dart';
import 'package:oppidum/views/widgets/app_bottom_navigation_action.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class OneMeetView extends StatefulWidget {
  final String id;
  final String meetId;
  OneMeetView({Key key, this.id, this.meetId}) : super(key: key);
  @override
  _OneMeetViewState createState() => _OneMeetViewState();
}

class _OneMeetViewState extends State<OneMeetView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLogin = false;
  String userId = '';
  bool isApprove = false;
  int numberOfApproval = 0;
  bool loading = false;
  bool _loadingButton = false;
  bool _didjoin = false;
  Map<String, dynamic> _meet;

  void updateMeet() async {
    if (mounted) {
      setState(() {
        _loadingButton = true;
      });
    }
    List<dynamic> participens = [
      ..._meet['participens'].map((p) {
        return p['_id'];
      })
    ];
    if (participens.indexOf(userId) == -1) {
      participens.add(userId);
    } else {
      participens.remove(userId);
    }

    var meet = await OppidumMeetApi.joinMeet(_meet['_id'], participens);
    if (mounted) {
      setState(() {
        _meet = meet;
        _loadingButton = false;
        _didjoin =
            meet['participens'].indexWhere((e) => e['_id'] == userId) == -1
                ? false
                : true;
      });
    }
  }

  void fetchOneMeet(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    var meet = await OppidumMeetApi.getMeetById(widget.meetId);
    print(meet['participens']);
    if (mounted) {
      setState(() {
        _meet = meet;
        loading = false;
        _didjoin =
            meet['participens'].indexWhere((e) => e['_id'] == userId) == -1
                ? false
                : true;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      fetchOneMeet(context);
      final SharedPreferences prefs = await _prefs;
      final token = prefs.getString('googlePYMP');
      Map<String, dynamic> payload = JwtDecoder.decode(token);

      if (mounted) {
        setState(() {
          userId = payload['_id'];
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    print(_didjoin);
    return Scaffold(
        appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.meet_view.titlePageVisit")),
        bottomNavigationBar: AppBottomNavigationAction(
            title: !_didjoin
                ? FlutterI18n.translate(context, "common.meet_view.joinVisit")
                : FlutterI18n.translate(context, "common.meet_view.exitVisit"),
            loading: _loadingButton,
            onPressed: () {
              updateMeet();
            }),
        body: Stack(children: [
          Container(decoration: new BoxDecoration(color: Color(0xff101519))),
          SingleChildScrollView(
              child: Column(children: [
            if (loading == true) LoadingAnnimation(),
            if (_meet != null)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment(-.2, 0),
                          image: NetworkImage(_meet['place']['image']['url']),
                          fit: BoxFit.cover),
                    ),
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: const FractionalOffset(.1, .4),
                              end: const FractionalOffset(.1, 1),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_meet['place']['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 3,
                                      fontSize: 20)),
                              CustomInkWell(
                                  onTap: () {
                                    MapsLauncher.launchQuery(
                                        _meet['place']['address']);
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(_meet['place']['address'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14)),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Icon(Icons.location_on,
                                              size: 30,
                                              color: Color(0xfff6ac65)),
                                        ),
                                      ]))
                            ]))),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      FlutterI18n.translate(context, "common.meet_view.creator") ,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    NetworkImage(_meet['owner']['picture']))),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(_meet['owner']['name'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)))
                      ])
                ]),
                Divider(color: Colors.grey),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    '${FlutterI18n.translate(context, "common.meet_view.debut")}: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_meet['startDate']))} ${FlutterI18n.translate(context, "common.meet_view.at")} ${DateFormat('hh:mm').format(DateTime.parse(_meet['startDate']))}',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: MarkdownBody(
                      data: _meet['title'] ?? '',
                      extensionSet: md.ExtensionSet.gitHubWeb,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: TextStyle(color: Colors.white),
                                  checkbox: TextStyle(color: Colors.white),
                                  blockquote: TextStyle(color: Colors.white),
                                  tableBody: TextStyle(color: Colors.white),
                                  h1: TextStyle(color: Colors.white),
                                  h2: TextStyle(color: Colors.white),
                                  h3: TextStyle(color: Colors.white),
                                  h4: TextStyle(color: Colors.white),
                                  h5: TextStyle(color: Colors.white),
                                  h6: TextStyle(color: Colors.white),
                                  listBullet: TextStyle(color: Colors.white)),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: MarkdownBody(
                      data: _meet['description'] ?? '',
                      extensionSet: md.ExtensionSet.gitHubWeb,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: TextStyle(color: Colors.white),
                                  checkbox: TextStyle(color: Colors.white),
                                  blockquote: TextStyle(color: Colors.white),
                                  tableBody: TextStyle(color: Colors.white),
                                  h1: TextStyle(color: Colors.white),
                                  h2: TextStyle(color: Colors.white),
                                  h3: TextStyle(color: Colors.white),
                                  h4: TextStyle(color: Colors.white),
                                  h5: TextStyle(color: Colors.white),
                                  h6: TextStyle(color: Colors.white),
                                  listBullet: TextStyle(color: Colors.white)),
                    )),
                Divider(),
              ])
          ]))
        ]));
  }
}
