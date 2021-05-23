import 'package:flutter/widgets.dart';

class CarcassonneLogo extends StatelessWidget {
  final double size;

  CarcassonneLogo({this.size});

  @override
  Widget build(BuildContext context) {
    return (Image.asset('assets/icon.png', width: size));
  }
}