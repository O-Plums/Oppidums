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
import 'package:carcassonne/net/comment_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:carcassonne/net/user_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  List<dynamic> _comments = [];
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
    var place = await CarcassonnePlaceApi.getPlaceById(widget.placeId);
    var comments =
        await CarcassonneCommentApi.getCommentByPlace(widget.placeId);
    if (mounted) {
      setState(() {
        _place = place;
        numberOfApproval = place['numberOfApproval'];
        loading = false;
        _comments = comments;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      fetchPlace(context);
      await _checkLocalStorage(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Place'),
        body: Stack(children: [
          Container(decoration: new BoxDecoration(color: Color(0xff101519))),
          SingleChildScrollView(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              size: 30,
                                              color: Color(0xfff6ac65)),
                                        ),
                                      ]))
                            ]))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: MarkdownBody(
                      data: _place['description'] ?? '',
                      extensionSet: md.ExtensionSet.gitHubWeb,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: TextStyle(color: Colors.white),
                                  checkbox: TextStyle(color: Colors.white),
                                  blockquote: TextStyle(color: Colors.white),
                                  tableBody: TextStyle(color: Colors.white),
                                  h1: TextStyle(color: Colors.white),
                                  h2: TextStyle(color: Colors.white),
                                  h3: TextStyle(color: Colors.white),
                                  h4: TextStyle(color: Colors.white),
                                  h5: TextStyle(color: Colors.white),
                                  h6: TextStyle(color: Colors.white),
                                  listBullet: TextStyle(color: Colors.white)),
                    )),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomInkWell(
                          onTap: isLogin == false
                              ? () {
                                  showMaterialModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      expand: false,
                                      builder: (context) => AuthWidget(
                                            onValidate: () {
                                              _checkLocalStorage(context);
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
                                            ? Colors.white
                                            : Colors.green),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Approuver',
                                            style: TextStyle(
                                                color: Colors.white))),
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
                                              _checkLocalStorage(context);
                                            },
                                          ));
                                }
                              : () {
                                  showMaterialModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      expand: false,
                                      builder: (context) => CommentWidget(
                                            onValidate: (comment) {
                                              _comments.insert(0 ,comment);

                                              setState(() {
                                                _comments = _comments;
                                              });
                                              // _showDialog(context);
                                            },
                                            placeId: widget.placeId,
                                          ));
                                },
                          child: Container(
                              width: 150,
                              margin: EdgeInsets.all(10),
                              child: Row(children: [
                                Icon(Icons.chat_bubble_outline,
                                    size: 20, color: Colors.white),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text('Commenter',
                                        style: TextStyle(color: Colors.white))),
                              ])))
                    ]),
                Divider(color: Colors.white),
                ..._comments.map((comment) {
                  return (Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff101519),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                                  NetworkImage(comment['app_user']['picture'])),
                          Padding(padding: EdgeInsets.only(top: 10),
                          child: 
                          Text(comment['app_user']['name'],
                           style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white) )
                          )]),
                          VerticalDivider(
                            color: Colors.red,
                            thickness: 1,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment['title'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  // Divider(color: Colors.red,
                                  //    thickness: 1.0,
                                  // ),
                                  Container(
                                    width: 225,
                                    child:
                                Text(comment['description'],
                                      maxLines: 20,
                                    
                                      style: TextStyle(color: Colors.white))
                                  )],
                              ))
                        ],
                      )));
                }).toList()
              ])
          ]))
        ]));
  }
}