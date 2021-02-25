import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/views/home/widgets/navigation_bottom_bar.dart';
import 'package:carcassonne/views/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/models/user_model.dart';
import 'package:carcassonne/router.dart';
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
    // ProgramView(),
    Container(),
    // NutritionView(),
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
    // Initialisation of intercom
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: JimAppBar(
          actions: <Widget>[
            if (tabIndex == 0)
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  AppRouter.router.navigateTo(context, 'calendar',
                      replace: false, transition: TransitionType.inFromRight);
                },
              ),
            if (tabIndex == 3)
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  AppRouter.router.navigateTo(context, 'profile/edit',
                      replace: false, transition: TransitionType.inFromRight);
                },
              ),
          ],
        ),
        drawer: JimAppDrawer(),
        // if we need to add drawer in the right
        // endDrawer: JimAppDrawer(),
        bottomNavigationBar: NavigationBottomBar(
            currentIndex: tabIndex, onChangeIndex: _handleChangeIndex),
        body: Container(
          child: bottomBarPages[tabIndex],
        ));
  }
}
