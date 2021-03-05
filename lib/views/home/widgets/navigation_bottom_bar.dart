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
          icon: Icon(Icons.location_city),
          label: 'Tourisme',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_shade),
          label: 'Histoire',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_stories),
          label: 'Culture',
        ),
      ],
      selectedItemColor: Color(0xffab9bd9),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
    );
  }
}