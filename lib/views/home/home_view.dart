import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/widgets/app_bottom_navigation_action.dart';
import 'package:oppidum/views/widgets/app_drawer.dart';
import 'package:oppidum/views/home/cult/cult_view.dart';
import 'package:oppidum/views/home/history/history_view.dart';
import 'package:oppidum/views/home/tourism/tourism_view.dart';
import 'package:oppidum/views/home/allPlaces/all_places.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidum/router.dart';
import 'package:fluro/fluro.dart';


class HomeView extends StatefulWidget {
  final bool showReminder;

  HomeView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int tabIndex = 0;

  List<Widget> bottomBarPages = <Widget>[
    TourismeView(),
    HistoryView(),
    CultView(),
  ];

  void _handleChangeIndex(int index) {
    if (mounted) {
      setState(() {
        tabIndex = index;
      });
    }
  }

  @override
  void initState() {
   
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomAppDrawer(),
        // if we need to add drawer in the right
           bottomNavigationBar: AppBottomNavigationAction(
            title: FlutterI18n.translate(context, "common.app_drawer.changeCity"),
            loading: false,
            onPressed: () {
              AppRouter.router.navigateTo(context, 'city',
                        replace: true, transition: TransitionType.inFromLeft);
            }),
        body: Container(
          //  color: Colors.black,

          child: AllPlaces(),//bottomBarPages[tabIndex],
        ));
  }
}
