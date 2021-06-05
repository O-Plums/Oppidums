import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/logo.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;
  final Function onBack;

  CustomAppBar({Key key, this.actions, this.title, this.onBack}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
            title: title != null
                ? Text(title, style: TextStyle(color: Colors.white))
                : OppidumLogo(size: 45),
            brightness: Brightness.dark, // status bar brightness
            automaticallyImplyLeading: true,
            leading: onBack == null
                ? null
                : IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: onBack,
                  ),
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.white),
            actions: actions,
            backgroundColor: Color(0xff090f13),

             ));
  }
}
