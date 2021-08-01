import 'package:flutter/widgets.dart';

class OppidumsLogo extends StatelessWidget {
  final double size;

  OppidumsLogo({this.size});

  @override
  Widget build(BuildContext context) {
    return (Image.asset('assets/oppidums_transparent.png', width: size));
  }
}