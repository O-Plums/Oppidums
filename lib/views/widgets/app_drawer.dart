import 'package:flutter/material.dart';
import 'package:oppidum/router.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidum/views/widgets/app_flat_button.dart';
import 'package:provider/provider.dart';
import 'package:oppidum/models/city_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oppidum/views/widgets/auth_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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

  Map<String, dynamic> _citie = null;

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
                height: 125,
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image: NetworkImage(
                              picture ?? 'assets/image_loading.gif'),
                          fit: BoxFit.cover),
                      //  borderRadius: BorderRadius.only(
                      //     bottomRight: Radius.circular(40),
                      //   ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (name != null)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 170,
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  CustomFlatButton(
                                    loadingColor: Colors.white,
                                    color: Colors.transparent,
                                    borderWidth: 2,
                                    borderColor: Colors.white,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      AppRouter.router.navigateTo(
                                          context, 'city/info',
                                          replace: false,
                                          transition:
                                              TransitionType.inFromRight);
                                    },
                                    fontSize: 12,
                                    label: FlutterI18n.translate(context, "common.app_drawer.seeCity"),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    )),
              ),
              ListTile(
                  onTap: () {
                    AppRouter.router.navigateTo(context, 'calendar',
                        replace: false, transition: TransitionType.inFromRight);
                  },
                  leading: Icon(Icons.calendar_today, color: Color(0xfff6ac65)),
                  title:
                      Text(FlutterI18n.translate(context, "common.calendar.titleCalendar"), style: TextStyle(color: Colors.white))),
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
                      AppRouter.router.navigateTo(context, 'meet',
                          replace: false,
                          transition: TransitionType.inFromRight);
                    }
                  },
                  leading: Icon(Icons.people, color: Color(0xfff6ac65)),
                  title:
                      Text(FlutterI18n.translate(context, "common.meet_view.titlePageVisit"), style: TextStyle(color: Colors.white))),
             
              ListTile(
                  onTap: () {
                    AppRouter.router.navigateTo(context, 'city',
                        replace: true, transition: TransitionType.inFromLeft);
                  },
                  leading: Icon(Icons.swap_calls, color: Color(0xfff6ac65)),
                  title: Text(FlutterI18n.translate(context, "common.app_drawer.changeCity"),
                      style: TextStyle(color: Colors.white))),
              Expanded(child: Container()),
       
              Divider(color: Colors.grey),
              if (isLogin)
                ListTile(
                    onTap: () async {
                      final SharedPreferences prefs = await _prefs;
                      prefs.setString('googlePYMP', null);
                      _checkLocalStorage(context);
                    },
                    leading: Icon(Icons.exit_to_app, color: Color(0xfff6ac65)),
                    title:
                        Text(FlutterI18n.translate(context, "common.app_drawer.logOut"), style: TextStyle(color: Colors.white))),
             
             
                     //  ListTile(
                //     onTap: () async {
                //       final SharedPreferences prefs = await _prefs;
                //       prefs.setString('googlePYMP', null);
                //       _checkLocalStorage(context);
                //     },
                //     leading: Icon(Icons.code, color: Color(0xfff6ac65)),
                //     title:Text('Git hub', style: TextStyle(color: Colors.white))),
            ])));
  }
}
