import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:carcassonne/views/widgets/auth_widget.dart';
import 'package:carcassonne/views/widgets/comment_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:carcassonne/views/widgets/loading_widget.dart';
import 'package:carcassonne/net/place_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:carcassonne/net/user_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// var fakeComments = [
//   {
//     "picture":
//         "https://upload.wikimedia.org/wikipedia/commons/a/a0/Pierre-Person.jpg",
//     "name": "Pierre",
//     "comment": "Super grec pour manger avec c\'est pote",
//   },
//   {
//     "picture":
//         "https://upload.wikimedia.org/wikipedia/commons/a/a0/Pierre-Person.jpg",
//     "name": "Pierre",
//     "comment": "Super grec pour manger avec c\'est pote",
//   },
//   {
//     "picture":
//         "https://upload.wikimedia.org/wikipedia/commons/a/a0/Pierre-Person.jpg",
//     "name": "Pierre",
//     "comment": "Super grec pour manger avec c\'est pote",
//   }
// ];

class PlaceView extends StatefulWidget {
  final String id;
  final String placeId;
  PlaceView({Key key, this.id, this.placeId}) : super(key: key);
  @override
  _PlaceViewViewState createState() => _PlaceViewViewState();
}

class _PlaceViewViewState extends State<PlaceView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLogin = false;
  bool isApprove = false;
  int numberOfApproval = 0;
  bool loading = false;
  Map<String, dynamic> _place = null;

  void _setApproval() async {
    final SharedPreferences prefs = await _prefs;

    final token = prefs.getString('googlePYMP');

    Map<String, dynamic> payload = JwtDecoder.decode(token);

    await CarcassonneUserApi.updateApproval(payload['_id'], _place['_id']);
    setState(() {
      isApprove = !isApprove;
    });
  }

  void _checkLocalStorage(context) async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');

    if (token != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  void fetchPlace(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    print('placeId ${widget.placeId}');
    var place = await CarcassonnePlaceApi.getPlaceById(widget.placeId);
    print('Place => $place');
    if (mounted) {
      setState(() {
        _place = place;
        numberOfApproval = place['numberOfApproval'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      //TODO mon applle a la base de donner
      fetchPlace(context);
      await _checkLocalStorage(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Place'),
        body: SingleChildScrollView(
            child: Column(children: [
          if (loading == true) LoadingAnnimation(),
          if (_place != null)
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment(-.2, 0),
                        image: NetworkImage(_place['image']['url']),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: const FractionalOffset(.1, .4),
                            end: const FractionalOffset(.1, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_place['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 3,
                                    fontSize: 20)),
                            CustomInkWell(
                                onTap: () {
                                  MapsLauncher.launchQuery(_place['address']);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_place['address'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14)),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Icon(Icons.location_on,
                                            size: 30, color: Color(0xfff6ac65)),
                                      ),
                                    ]))
                          ]))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: MarkdownBody(
                    data: _place['description'],
                    extensionSet: md.ExtensionSet.gitHubWeb,
                  )),
              /*Padding(
                  padding: EdgeInsets.all(10),
                  child: MarkdownBody(
                    data: _place['more_info_1'],
                    extensionSet: md.ExtensionSet.gitHubWeb,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: MarkdownBody(
                    data: _place['more_info_2'],
                    extensionSet: md.ExtensionSet.gitHubWeb,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: MarkdownBody(
                    data: _place['more_info_3'],
                    extensionSet: md.ExtensionSet.gitHubWeb,
                  )),*/
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                CustomInkWell(
                    onTap: isLogin == false
                        ? () {
                            showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                expand: false,
                                builder: (context) => AuthWidget(
                                      onValidate: () {
                                        // _showDialog(context);
                                      },
                                    ));
                          }
                        : () {
                            _setApproval();
                          },
                    child: Container(
                        width: 150,
                        margin: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.check_circle,
                                  size: 20,
                                  color: !isApprove
                                      ? Colors.grey.shade600
                                      : Colors.green),
                              Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text('Approuver',
                                      style: TextStyle(
                                          color: Colors.grey.shade600))),
                            ]))),
                Text('|'),
                CustomInkWell(
                    onTap: isLogin == false
                        ? () {
                            showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                expand: false,
                                builder: (context) => AuthWidget(
                                      onValidate: () {
                                        // _showDialog(context);
                                      },
                                    ));
                          }
                        : () {
                            showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                expand: false,
                                builder: (context) => CommentWidget(
                                      onValidate: () {
                                        // _showDialog(context);
                                      },
                                    ));
                          },
                    child: Container(
                        width: 150,
                        margin: EdgeInsets.all(10),
                        child: Row(children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 20, color: Colors.grey.shade600),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Commenter',
                                  style:
                                      TextStyle(color: Colors.grey.shade600))),
                        ])))
              ]),
            ])
        ])));
  }
}

    //         ...fakeComments.map((comment) {
    //             return (
    //               Container(
    //                 margin: EdgeInsets.all(10),
    //                 padding: EdgeInsets.all(10),
    //                 decoration: BoxDecoration(
    //   // border: Border.all(color: Color(0xffC4C4C4)),
    //   color: Colors.white,
    //   borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey.withOpacity(0.5),
    //       spreadRadius: 2,
    //       blurRadius: 2,
    //       offset: Offset(0, 3), // changes position of shadow
    //     ),
    //   ],
    // ),
    //                 child:
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                 CircleAvatar(
    //                   radius: 30.0,
    //                   backgroundImage: NetworkImage(comment['picture'])),
    //                 Container(
    //                   height: 60,
    //                 margin: EdgeInsets.only(left: 20),
    //                 child:
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                   Text(comment['name'],
    //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    //                   ),
    //                   Text(comment['comment'])
    //                 ],))

    //               ],))

    //             );
    //           }).toList()
//  CustomInkWell(
//               onTap: () {
//                 setState(() {
//                   isApprove = !isApprove;
//                   numberOfApproval = !isApprove
//                       ? numberOfApproval - 1
//                       : numberOfApproval + 1;
//                 });
//               },
//               child: Container(
//                   width: 100,
//                   padding: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     color:
//                         !isApprove ? Colors.grey.shade300 : Color(0xfff6ac65),
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 2,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [

//                         Icon(Icons.check_circle,
//                             size: 20,
//                             color: !isApprove
//                                 ? Colors.grey.shade600
//                                 : Colors.black),
//                                        Text('Approve',
//                             style: TextStyle(
//                                 color: !isApprove
//                                     ? Colors.grey.shade600
//                                     : Colors.black))
//                       ])))
