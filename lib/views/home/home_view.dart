import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/app_bar.dart';
import 'package:oppidums/views/widgets/app_drawer.dart';
import 'package:oppidums/views/home/allPlaces/all_places.dart';

class HomeView extends StatefulWidget {
  final bool showReminder;

  HomeView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int tabIndex = 0;

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
        body: Container(
          child: AllPlaces(), //bottomBarPages[tabIndex],
        ));
  }
}
