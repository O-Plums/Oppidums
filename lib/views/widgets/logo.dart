import 'package:flutter/widgets.dart';

class OppidumLogo extends StatelessWidget {
  final double size;

  OppidumLogo({this.size});

  @override
  Widget build(BuildContext context) {
    return (Image.asset('assets/oppidum_transparent.png', width: size));
  }
}