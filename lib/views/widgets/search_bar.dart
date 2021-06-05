import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oppidum/views/widgets/logo.dart';
import 'package:oppidum/views/widgets/input_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';


class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;
  final Function onChange;
  

  CustomSearchBar({Key key, this.actions, this.title, this.onChange}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
            title:Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left:20, right: 20),
              child:
              InputText(
                customDecoration:
                InputDecoration(
                   suffixIcon: Icon(Icons.search, color: Colors.grey,),
                   hintStyle: TextStyle(color: Colors.white),
            hintText: 
              FlutterI18n.translate(context, "common.city_view.searchCity"),
      contentPadding: EdgeInsets.only(left: 20),
                focusedBorder:  OutlineInputBorder(
         borderSide: new BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(
           Radius.circular(25.0),
        ),
      ),
                enabledBorder: OutlineInputBorder(
         borderSide: new BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(
           Radius.circular(25.0),
        ),
      )),
              onChange: onChange,
            )),
            brightness: Brightness.dark, // status bar brightness
            automaticallyImplyLeading: true,
            centerTitle: true,
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.white),
            actions: actions,
            backgroundColor: Color(0xff090f13),

             ));
  }
}
