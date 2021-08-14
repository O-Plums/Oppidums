import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:oppidums/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:oppidums/net/city_api.dart';
import 'package:provider/provider.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:oppidums/views/widgets/loading_widget.dart';
import 'package:share/share.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CityInfoView extends StatefulWidget {
  CityInfoView({Key key}) : super(key: key);

  @override
  _CityInfoViewState createState() => _CityInfoViewState();
}

class _CityInfoViewState extends State<CityInfoView> {
  bool isLogin = false;
  bool loading = false;
  List<dynamic> _imageGallery = [];
  Map<String, dynamic> _citie = null;

  void fetchCitie() async {
    var cityModel = Provider.of<CityModel>(context, listen: false);

    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var citie = await OppidumsCityApi.getCitieById(cityModel.id);
    if (mounted) {
      setState(() {
        _citie = citie;
        _imageGallery = citie['imageGallery'];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      fetchCitie();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: _citie != null ? _citie['name'] : '...',
          actions: [
            CustomInkWell(
                eventName: 'share_citie_${_citie != null ? _citie['id'] : ''}',
                onTap: () async {
                  Share.share("Decouvre ce lieu sur https://oppidums.com/${_citie['id']}");
                },
                child: Container(margin: EdgeInsets.only(right: 15), child: Icon(Icons.share, size: 25)))
          ],
        ),
        body: Stack(children: [
          Container(decoration: new BoxDecoration(color: Color(0xff101519))),
          SingleChildScrollView(
              child: Column(children: [
            if (loading == true) LoadingAnnimation(),
            if (_citie != null)
              Column(children: [
                Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment(-.2, 0), image: NetworkImage(_citie['image']['url']), fit: BoxFit.cover),
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
                              eventName: 'open_map_citie_${_citie['id']}',
                              onTap: () {
                                MapsLauncher.launchQuery(_citie['address']);
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                Container(
                                    width: 250,
                                    child: Text(_citie['address'],
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
                                        Icon(Icons.location_on, size: 30, color: Color(0xff8ec6f5)),
                                        Text(FlutterI18n.translate(context, "common.place_view.maps"),
                                            style: TextStyle(color: Colors.white, fontSize: 10)),
                                      ]),
                                ),
                              ]))
                        ]))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: MarkdownBody(
                      data: _citie['description'],
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
                if (_imageGallery.length > 0)
                  CarouselSlider(
                    options: CarouselOptions(
                      // height: 150,
                      // aspectRatio: 0.2,
                      // viewportFraction: 0.5,
                      // initialPage: 0,
                      enableInfiniteScroll: true,
                      // reverse: false,
                      enlargeCenterPage: true,
                      // scrollDirection: Axis.horizontal,
                    ),
                    items: _imageGallery.map((i) {
                      return Container(
                          child: ClipRRect(
                              // borderRadius: BorderRadius.all(Radius.circular(5)),
                              child:
                                  FadeInImage.assetNetwork(placeholder: 'assets/image_loading.gif', image: i['url'])));
                    }).toList(),
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                )
              ])
          ]))
        ]));
  }
}
