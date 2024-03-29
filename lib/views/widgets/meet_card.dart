import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/app_flat_button.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidums/net/meet_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppidums/views/widgets/app_inkwell.dart';

class MeetCard extends StatelessWidget {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final Map<String, dynamic> meet;
  final Function onPressed;
  final Function fetchMeet;

  final bool isDelPossible;

  MeetCard({this.meet, this.onPressed, this.isDelPossible, this.fetchMeet});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        child: CustomInkWell(
          eventName: 'open_meet_card_${meet['id']}',
          onTap: onPressed,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                        image: NetworkImage(meet['place']['image']['url'] ?? 'assets/image_loading.gif'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (isDelPossible)
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: double.infinity,
                          alignment: Alignment.topRight,
                          child: CustomFlatButton(
                            eventName: 'meet_view.deleteVisit',
                            disabledColor: Colors.grey,
                            label: FlutterI18n.translate(context, "common.meet_view.deleteVisit"),
                            textColor: Colors.black,
                            color: Colors.red,
                            onPressed: () async {
                              try {
                                final SharedPreferences prefs = await _prefs;
                                final token = prefs.getString('googlePYMP');
                                await OppidumsMeetApi.deleteMeetById(meet['_id'], token);
                                fetchMeet();
                              } catch (e) {
                                print(e);
                              }
                            },
                            width: 100,
                          ),
                        ),
                      Expanded(child: Container()),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(meet['title'],
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
                          Row(
                            children: [
                              Text(meet['participens'].length.toString() + ' ',
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold, color: Color(0xff4db9c2), fontSize: 18)),
                              Icon(Icons.people, color: Color(0xff4db9c2)),
                            ],
                          )
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(meet['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      Divider()
                    ],
                  ))),
        ));
  }
}
