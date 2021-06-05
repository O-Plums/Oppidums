import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_flat_button.dart';

class AppBottomNavigationAction extends StatelessWidget
implements PreferredSizeWidget {
  final bool loading;
  final String title;
  final Function onPressed;

  AppBottomNavigationAction(
      {Key key, this.loading, this.title, this.onPressed})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Color(0xff101519),
          
          border: Border(
              top: BorderSide(
        color: Colors.grey,
        width: 0.5,
      ))),
      height: 50,
      alignment: Alignment.bottomCenter,
      child: CustomFlatButton(
        loading: loading,
        width: 200,
        loadingColor: Color(0xfff6ac65),
        color: Colors.white,
        textColor: Colors.black,
        onPressed: onPressed,
        label: title,
      ),
    );
  }
}
