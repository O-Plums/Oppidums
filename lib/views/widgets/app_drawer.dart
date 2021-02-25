import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:carcassonne/app_config.dart';

class JimAppDrawer extends StatefulWidget {
  final String dateToGet;
  JimAppDrawer({Key key, this.dateToGet}) : super(key: key);
  @override
  _JimAppDrawerState createState() => _JimAppDrawerState();
}

class _JimAppDrawerState extends State<JimAppDrawer> {
  String completeName;
  String picture;
  bool isSubscribe = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:
              Container(
          height: 125,
          child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (picture != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(picture),
                      minRadius: 30,
                      maxRadius: 30,
                    ),
                  if (completeName != null)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                completeName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                                  ],
                        ),
                      ),
                    )
                ],
              )))
        );
  }
}
