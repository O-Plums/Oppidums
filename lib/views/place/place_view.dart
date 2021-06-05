import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:oppidum/views/widgets/auth_widget.dart';
import 'package:oppidum/views/widgets/comment_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:oppidum/views/widgets/loading_widget.dart';
import 'package:oppidum/net/place_api.dart';
import 'package:oppidum/net/comment_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oppidum/net/user_api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:flutter_i18n/flutter_i18n.dart';


class PlaceView extends StatefulWidget {
  final String id;
  final String placeId;
  PlaceView({Key key, this.id, this.placeId}) : super(key: key);
  @override
  _PlaceViewViewState createState() => _PlaceViewViewState();
}

class _PlaceViewViewState extends State<PlaceView>
    with TickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final assetsAudioPlayer = AssetsAudioPlayer();
  AnimationController _controller;
  bool isStarted = false;
  String _currentPos = '0:00:00';
  bool isLogin = false;
  bool isApprove = false;
  int numberOfApproval = 0;
  bool loading = false;
  List<dynamic> _comments = [];
  String userId = '';

  Map<String, dynamic> _place = null;

  void startStopAudio() async {
    bool isPlaying = assetsAudioPlayer.isPlaying.value;
    final Playing playing = assetsAudioPlayer.current.value;
    if (playing == null) {
      await assetsAudioPlayer
          .open(Audio.network(_place['audioDescription']['url']));
      assetsAudioPlayer.playlistFinished.listen((finished) {
        if (finished) {
          setState(() {
            isStarted = false;
          });
          assetsAudioPlayer.stop();
          _controller.reset();
        }
      });

      final duration = assetsAudioPlayer.current.value.audio.duration;
      _controller.duration = duration;
      _controller.forward();
      setState(() {
        isStarted = true;
      });
      Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          _currentPos =
              assetsAudioPlayer.currentPosition.value.toString().split('.')[0];
        });
      });
    }
    if (!isPlaying) {
      assetsAudioPlayer.play();
      _controller.forward();
      setState(() {
        isStarted = true;
      });
    } else {
      _controller.stop();
      assetsAudioPlayer.pause();
      setState(() {
        isStarted = false;
      });
    }
  }

  void _setApproval() async {
    bool tmpApprove = false;
    List<dynamic> approval = [
      ..._place['approval'].map((p) {
        return p['_id'];
      })
    ];
    if (approval.indexOf(userId) == -1) {
      approval.add(userId);
      tmpApprove = true;
    } else {
      tmpApprove = false;
      approval.remove(userId);
    }

    await OppidumPlaceApi.updateApproval(_place['_id'], approval);
    if (mounted) {
      setState(() {
        isApprove = tmpApprove;
      });
    }
  }

  void _checkLocalStorage(context) async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');

    if (token != null) {
      Map<String, dynamic> payload = JwtDecoder.decode(token);

      setState(() {
        isLogin = true;
        userId = payload['_id'];
        isApprove = 
            _place['approval'].indexWhere((e) => e['_id'] == userId) == -1
                ? false
                : true;
      });
    }
  }

  Future<void> fetchPlace(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var place = await OppidumPlaceApi.getPlaceById(widget.placeId);
    var comments =
        await OppidumCommentApi.getCommentByPlace(widget.placeId);
    if (mounted) {
      setState(() {
        _place = place;
        numberOfApproval = place['approval']?.length ?? 0;
        loading = false;
        _comments = comments;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      await fetchPlace(context);
       _checkLocalStorage(context);
      _controller = AnimationController(vsync: this);
    });
    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.pause();
    assetsAudioPlayer.stop();
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.place_view.titlePlace")),
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
                                        Container(
                                            width: 300,
                                            child: Text(_place['address'],
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14))),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Icon(Icons.location_on,
                                              size: 30,
                                              color: Color(0xfff6ac65)),
                                        ),
                                      ]))
                            ]))),
                if (_place['audioDescription'] != null &&
                    _place['audioDescription']['url'] != '')
                  CustomInkWell(
                      onTap: () async {
                        startStopAudio();
                      },
                      child: Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.all(10),
                          child: Row(children: [
                            Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  !isStarted
                                      ? Icons.play_circle_fill
                                      : Icons.pause_circle_filled,
                                  color: Color(0xfff6ac65),
                                )),
                            Container(
                                child: Lottie.asset(
                              'assets/lottie/audio-player.json',
                              controller: _controller,
                              height: 40,
                              width: 275,
                              repeat: false,
                            )),
                            Container(
                              child: Text(_currentPos,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white)),
                            )
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
                                    Icon(Icons.favorite_border_outlined,
                                        size: 20,
                                        color: !isApprove
                                            ? Colors.white
                                            : Colors.green),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(FlutterI18n.translate(context, "common.common_word.like"),
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ]))),
                      Text('|', style: TextStyle(color: Colors.grey)),
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
                              : () async {
                                  showMaterialModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      expand: false,
                                      builder: (context) => CommentWidget(
                                            onValidate: (comment) {
                                              _comments.insert(0, comment);

                                              setState(() {
                                                _comments = _comments;
                                              });
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
                                    child: Text(FlutterI18n.translate(context, "common.place_view.comment"),
                                        style: TextStyle(color: Colors.white))),
                              ])))
                    ]),
                Divider(color: Colors.white),
                ..._comments.map((comment) {
                  return (Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xff101519),
                        border: Border.all(color: Colors.grey),
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
                                    radius: 15.0,
                                    backgroundImage: NetworkImage(
                                        comment['app_user']['picture'])),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(comment['app_user']['name'],
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)))
                              ]),
                          VerticalDivider(
                            color: Colors.red,
                            thickness: 1,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 210,
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(comment['title'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  Container(
                                      width: 210,
                                      child: Text(comment['description'],
                                          maxLines: 20,
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              )),
                          if (comment['app_user']['_id'] == userId)
                            CustomInkWell(
                                onTap: () async {
                                  await OppidumCommentApi.deleteCommentById(
                                      comment['_id']);
                                  _comments.removeWhere(
                                      (c) => c['_id'] == comment['_id']);
                                  setState(() {
                                    _comments = _comments;
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                )),
                        ],
                      )));
                }).toList()
              ])
          ]))
        ]));
  }
}
