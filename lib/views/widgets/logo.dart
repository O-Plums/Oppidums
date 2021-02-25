import 'package:flutter/widgets.dart';

class JimLogo extends StatelessWidget {
  final double size;

  JimLogo({this.size});

  @override
  Widget build(BuildContext context) {
    return (Image.asset('assets/icon.jpeg', width: size));
  }
}