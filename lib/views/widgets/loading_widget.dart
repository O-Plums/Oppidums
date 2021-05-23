import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class LoadingAnnimation extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  width: double.infinity,
        // height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Lottie.asset('assets/lottie/city1.json',
        // fit: BoxFit.fill,
        ));
  }
}
