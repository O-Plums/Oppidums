import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/home/widgets/navigation_bottom_bar.dart';
import 'package:oppidum/views/widgets/app_drawer.dart';
import 'package:oppidum/views/home/cult/cult_view.dart';
import 'package:oppidum/views/home/history/history_view.dart';
import 'package:oppidum/views/home/tourism/tourism_view.dart';

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
        bottomNavigationBar: NavigationBottomBar(
            currentIndex: tabIndex, onChangeIndex: _handleChangeIndex),
        body: Container(
          //  color: Colors.black,

          child: bottomBarPages[tabIndex],
        ));
  }
}
