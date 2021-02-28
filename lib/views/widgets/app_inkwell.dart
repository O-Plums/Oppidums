import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final Function() onTap;
  final String eventName;
  final Widget child;
  final bool lock;
  final double lockIconPositionTop;
  final double lockIconPositionLeft;
  final double lockIconPositionBottom;
  final double lockIconPositionRight;
  final Color lockIconColor;

  CustomInkWell(
      {this.child,
      this.onTap,
      this.eventName,
      this.lock = false,
      this.lockIconPositionTop,
      this.lockIconPositionLeft,
      this.lockIconPositionBottom,
      this.lockIconPositionRight,
      this.lockIconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            child,
            if (lock == true)
              (Positioned(
                  top: lockIconPositionTop,
                  left: lockIconPositionLeft,
                  bottom: lockIconPositionBottom,
                  right: lockIconPositionRight,
                  child: Icon(Icons.lock,
                      color: lockIconColor != null
                          ? lockIconColor
                          : Colors.black)))
          ],
        ));
  }
}
