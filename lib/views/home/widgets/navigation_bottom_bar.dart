import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class NavigationBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function onChangeIndex;

  NavigationBottomBar({this.currentIndex, this.onChangeIndex});

  @override
  _NavigationBottomBarState createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  void _onItemTapped(int index) {
    widget.onChangeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: FlutterI18n.translate(context, 'common.router.program'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: FlutterI18n.translate(context, 'common.router.chat'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.content_paste),
          label: FlutterI18n.translate(context, 'common.router.exploreTitle'),
        ),
      ],
      selectedItemColor: Color(0xffEA178C),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
    );
  }
}