import 'package:flutter/material.dart';
import 'package:oppidums/analytics.dart';
import 'package:oppidums/app_config.dart';

class CustomFlatButton extends StatelessWidget {
  final Function() onPressed;
  final String eventName;
  final String label;
  final Color color;
  final Color textColor;
  final double width;
  final double height;
  final bool loading;
  final bool disabled;
  final Color loadingColor;
  final Color disabledColor;
  final bool lock;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double fontSize;

  CustomFlatButton({
    this.label,
    this.fontSize,
    this.onPressed,
    this.eventName,
    this.lock = false,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.disabledColor,
    this.disabled,
    this.loading = false,
    this.loadingColor = const Color(0xff8ec6f5),
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (AppConfig.env == 'production') {
            OppidumsAnalytics.analytics.logEvent(eventName ?? 'need_to_add_eventName_button');
        }
        onPressed();
      },
      // disabledColor: disabledColor,
      // textColor: textColor,
      child: loading == false
          ? (Container(
               padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
               decoration: ShapeDecoration(
                  color: color != null ? color : Colors.black,
                  shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(borderRadius ?? 15.0),
                  side: BorderSide(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth ?? 0,
                  style: BorderStyle.solid))),
              child: Text(
                label,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 14,
                ),
                textAlign: TextAlign.center,
              )))
          : (SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: new AlwaysStoppedAnimation<Color>(loadingColor),
              ),
              height: 20.0,
              width: 20.0,
            )),
    );
  }
}
