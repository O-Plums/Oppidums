import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/app_bar.dart';
import 'package:oppidums/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:oppidums/views/widgets/auth_widget.dart';
import 'package:oppidums/views/widgets/comment_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:oppidums/views/widgets/loading_widget.dart';
import 'package:oppidums/net/place_api.dart';
import 'package:oppidums/net/comment_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';
import 'package:oppidums/router.dart';
import 'package:fluro/fluro.dart';

class PlaceView extends StatefulWidget {
  final String id;
  final String placeId;
  PlaceView({Key key, this.id, this.placeId}) : super(key: key);
  @override
  _PlaceViewViewState createState() => _PlaceViewViewState();
}

class _PlaceViewViewState extends State<PlaceView> with TickerProviderStateMixin {
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
    bool isPlaying = assetsAudioPlayer?.isPlaying?.value;
    final Playing playing = assetsAudioPlayer?.current?.valueOrNull;
    if (playing == null) {
      await assetsAudioPlayer.open(Audio.network(_place['audioDescription']['url']));
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
          _currentPos = assetsAudioPlayer.currentPosition.value.toString().split('.')[0];
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
      tmpApprove = true;
    } else {
      tmpApprove = false;
    }
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('googlePYMP');
    await OppidumsPlaceApi.updateApproval(_place['_id'], userId, token);
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
        isApprove = _place['approval'].indexWhere((e) => e['_id'] == userId) == -1 ? false : true;
      });
    }
  }

  Future<void> fetchPlace(context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      var place = await OppidumsPlaceApi.getPlaceById(widget.placeId);
      var comments = await OppidumsCommentApi.getCommentByPlace(widget.placeId);
      if (mounted) {
        setState(() {
          _place = place;
          numberOfApproval = place['approval']?.length ?? 0;
          loading = false;
          _comments = comments;
        });
      }
    } catch (e) {
      print(e);
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
        appBar: CustomAppBar(
          title: _place != null ? _place['name'] : '...',
          actions: [
            CustomInkWell(
                eventName: 'share_place_${_place != null ? _place['id'] : ''}',
                onTap: () async {
                  final SharedPreferences prefs = await _prefs;
                  final String cityId = prefs.getString('cityId');
                  Share.share("Decouvre ce lieu sur https://oppidums.com/${cityId}/${_place['_id']}");
                },
                child: Container(margin: EdgeInsets.only(right: 15), child: Icon(Icons.share, size: 25)))
          ],
        ),
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
                          alignment: Alignment(-.2, 0), image: NetworkImage(_place['image']['url']), fit: BoxFit.cover),
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
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          CustomInkWell(
                              eventName: 'open_map_of_place_${_place['id']}',
                              onTap: () {
                                MapsLauncher.launchQuery(_place['address']);
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                Container(
                                    width: 250,
                                    child: Text(_place['address'],
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14))),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on, size: 30, color: Color(0xff4db9c2)),
                                        Text(FlutterI18n.translate(context, "common.place_view.maps"),
                                            style: TextStyle(color: Colors.white, fontSize: 10)),
                                      ]),
                                ),
                              ]))
                        ]))),
                if (_place['audioDescription'] != null && _place['audioDescription']['url'] != '')
                  CustomInkWell(
                      eventName: 'star_audioDescription_${_place['id']}',
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
                                  !isStarted ? Icons.play_circle_fill : Icons.pause_circle_filled,
                                  color: Color(0xff4db9c2),
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
                              child: Text(_currentPos, style: TextStyle(fontSize: 10, color: Colors.white)),
                            )
                          ]))),
                if (_place['imageGallery'] != null && _place['imageGallery'].length > 0)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 0.1,
                      viewportFraction: 0.6,
                      // initialPage: 0,
                      enableInfiniteScroll: true,
                      // reverse: false,
                      enlargeCenterPage: true,
                      // scrollDirection: Axis.horizontal,
                    ),
                    items: _place['imageGallery'].map<Widget>((i) {
                      return Container(
                          child: ClipRRect(
                              // borderRadius: BorderRadius.all(Radius.circular(5)),
                              child:
                                  FadeInImage.assetNetwork(placeholder: 'assets/image_loading.gif', image: i['url'])));
                    }).toList(),
                  ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: MarkdownBody(
                      data: _place['description'] ?? '',
                      extensionSet: md.ExtensionSet.gitHubWeb,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  CustomInkWell(
                      eventName: 'click_on_approval_${_place['id']}',
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
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Icon(Icons.favorite_border_outlined,
                                size: 20, color: !isApprove ? Colors.white : Colors.green),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(FlutterI18n.translate(context, "common.common_word.like"),
                                    style: TextStyle(color: Colors.white))),
                          ]))),
                  Text('|', style: TextStyle(color: Colors.grey)),
                  CustomInkWell(
                      eventName: 'click_on_add_comment_${_place['id']}',
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
                            Icon(Icons.chat_bubble_outline, size: 20, color: Colors.white),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(FlutterI18n.translate(context, "common.place_view.comment"),
                                    style: TextStyle(color: Colors.white))),
                          ])))
                ]),
                Divider(color: Colors.white),
                CustomInkWell(
                    eventName: 'click_on_go_to_meet_${_place['id']}',
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
                            AppRouter.router
                                .navigateTo(context, 'meet', replace: false, transition: TransitionType.inFromRight);
                          },
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.people, color: Colors.white),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(FlutterI18n.translate(context, "common.place_view.meetTitle"),
                                  style: TextStyle(color: Colors.white))),
                        ]))),
                if (_comments.length > 0) Divider(color: Colors.white),
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
                          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            CircleAvatar(
                                radius: 15.0, backgroundImage: NetworkImage(comment['app_user']['picture'] ?? '')),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(comment['app_user']['name'],
                                    style: TextStyle(fontSize: 10, color: Colors.white)))
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
                                        style:
                                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                  Container(
                                      width: 210,
                                      child: Text(comment['description'],
                                          maxLines: 20, style: TextStyle(color: Colors.white)))
                                ],
                              )),
                          if (comment['app_user']['_id'] == userId)
                            CustomInkWell(
                                eventName: 'click_delete_comment_${_place['id']}',
                                onTap: () async {
                                  try {
                                    final SharedPreferences prefs = await _prefs;
                                    final token = prefs.getString('googlePYMP');
                                    await OppidumsCommentApi.deleteCommentById(comment['_id'], token);
                                    _comments.removeWhere((c) => c['_id'] == comment['_id']);
                                    setState(() {
                                      _comments = _comments;
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
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
