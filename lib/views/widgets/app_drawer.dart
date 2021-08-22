import 'package:flutter/material.dart';
import 'package:oppidums/router.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidums/views/widgets/app_flat_button.dart';
import 'package:provider/provider.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oppidums/views/widgets/auth_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomAppDrawer extends StatefulWidget {
  final String dateToGet;
  CustomAppDrawer({Key key, this.dateToGet}) : super(key: key);
  @override
  _CustomAppDrawerState createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String name;
  String picture;
  bool isSubscribe = false;
  bool isLogin = false;
  String version = '0.0.0';

// String buildNumber = packageInfo.buildNumber;

  Map<String, dynamic> _citie = null;

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo);
    if (mounted) {
      setState(() {
        version = packageInfo.version;
      });
    }
  }

  void _checkLocalStorage(context) async {
    final SharedPreferences prefs = await _prefs;

    final token = prefs.getString('googlePYMP');

    if (token != null) {
      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {
      _checkLocalStorage(context);
      _getVersion();

      if (mounted) {
        var cityModel = Provider.of<CityModel>(context, listen: false);

        setState(() {
          picture = cityModel.url;
          name = cityModel.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Color(0xff101519),
            child: Column(children: [
              Container(
                height: 170,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(picture ?? 'assets/image_loading.gif'), fit: BoxFit.cover)),
                  child: Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: const FractionalOffset(.1, .4),
                            end: const FractionalOffset(.1, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: CustomFlatButton(
                              eventName: 'app_drawer.seeCity',
                              loadingColor: Colors.white,
                              color: Colors.transparent,
                              borderWidth: 2,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              onPressed: () {
                                AppRouter.router.navigateTo(context, 'city/info',
                                    replace: false, transition: TransitionType.inFromRight);
                              },
                              fontSize: 12,
                              label: FlutterI18n.translate(context, "common.app_drawer.seeCity"),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                  onTap: () {
                    AppRouter.router
                        .navigateTo(context, 'calendar', replace: false, transition: TransitionType.inFromRight);
                  },
                  leading: Icon(Icons.calendar_today, color: Color(0xff4db9c2)),
                  title: Text(FlutterI18n.translate(context, "common.calendar.titleCalendar"),
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  onTap: () {
                    if (isLogin == false) {
                      showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          expand: false,
                          builder: (context) => AuthWidget(
                                onValidate: () {
                                  _checkLocalStorage(context);
                                },
                              ));
                    } else {
                      AppRouter.router
                          .navigateTo(context, 'meet', replace: false, transition: TransitionType.inFromRight);
                    }
                  },
                  leading: Icon(Icons.people, color: Color(0xff4db9c2)),
                  title: Text(FlutterI18n.translate(context, "common.meet_view.titlePageVisit"),
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  onTap: () {
                    AppRouter.router.navigateTo(context, 'city', replace: true, transition: TransitionType.inFromLeft);
                  },
                  leading: Icon(Icons.swap_calls, color: Color(0xff4db9c2)),
                  title: Text(FlutterI18n.translate(context, "common.app_drawer.changeCity"),
                      style: TextStyle(color: Colors.white))),
              Expanded(child: Container()),
              if (isLogin) Divider(color: Colors.grey),
              if (isLogin)
                ListTile(
                    onTap: () async {
                      final SharedPreferences prefs = await _prefs;
                      prefs.remove('googlePYMP');
                      _checkLocalStorage(context);
                    },
                    leading: Icon(Icons.exit_to_app, color: Color(0xff4db9c2)),
                    title: Text(FlutterI18n.translate(context, "common.app_drawer.logOut"),
                        style: TextStyle(color: Colors.white))),
              Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
                  child: (Text(
                    'Version: ${version}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.left,
                  )))
            ])));
  }
}
