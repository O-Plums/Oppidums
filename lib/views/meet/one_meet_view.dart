import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:carcassonne/views/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carcassonne/net/user_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:carcassonne/net/meet_api.dart';
import 'package:carcassonne/views/widgets/app_bottom_navigation_action.dart';


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
  bool isApprove = false;
  int numberOfApproval = 0;
  bool loading = false;
  Map<String, dynamic> _meet = null;

  void _setApproval() async {
    final SharedPreferences prefs = await _prefs;

    final token = prefs.getString('googlePYMP');

    Map<String, dynamic> payload = JwtDecoder.decode(token);

    await CarcassonneUserApi.updateApproval(payload['_id'], _meet['_id']);
    setState(() {
      isApprove = !isApprove;
    });
  }

  void _checkLocalStorage(context) async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');

    if (token != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  void fetchOneMeet(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    // print('Toto =>${widget.meetId}');

    var meet = await CarcassonneMeetApi.getMeetById(widget.meetId);
    // print(meet);
    if (mounted) {
      setState(() {
        _meet = meet;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      fetchOneMeet(context);
      await _checkLocalStorage(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Ma rencontre'),
        bottomNavigationBar: AppBottomNavigationAction(
            title: 'Rejoindre cette rencontre',
            loading: false,
            onPressed: () {
              showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                expand: false,
                // builder: (context) => AddCityWidget(
                //   onValidate: () {
                //     _showDialog(context);
                //   },
                // ),
              );
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
