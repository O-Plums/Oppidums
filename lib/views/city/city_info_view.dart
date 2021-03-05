import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

var fakeCity = {
  "image":
      "https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Nivelles2011.JPG/280px-Nivelles2011.JPG",
  "name": "Nivelles",
  "description": "* Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\"arrondissement administratif et judiciaire de Nivelles.",
  "population": 28521,
  "type": "small",
  "countryCode": "BR",
  "imageGallery": [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Nivelles_JPG00_%289%29.jpg/170px-Nivelles_JPG00_%289%29.jpg",
    "http://photos.wikimapia.org/p/00/03/56/50/92_big.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Street_in_Nivelles%2C_Belgium_Independence_Day.JPG/1280px-Street_in_Nivelles%2C_Belgium_Independence_Day.JPG"
    "https://woody.cloudly.space/app/uploads/ville-saintes/2018/12/palais-de-justice-nivelles-redim-1920x960-crop-1543845892.jpg"
  ],
  "address": "1400 Nivelles, Belgium",

};

List imageGallery = [
  'http://photos.wikimapia.org/p/00/03/56/50/92_big.jpg',
  'http://photos.wikimapia.org/p/00/03/56/50/92_big.jpg',
  'http://photos.wikimapia.org/p/00/03/56/50/92_big.jpg',
  'http://photos.wikimapia.org/p/00/03/56/50/92_big.jpg'
];

class CityInfoView extends StatefulWidget {
  final String id;

  CityInfoView({Key key, this.id}) : super(key: key);

  @override
  _CityInfoViewState createState() => _CityInfoViewState();
}

class _CityInfoViewState extends State<CityInfoView> {
  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      //TODO mon applle a la base de donner
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'City'),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment(-.2, 0),
                    image: NetworkImage(fakeCity['image']),
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
                    Text(fakeCity['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22)),

                             CustomInkWell(
                  onTap: (){
                  MapsLauncher.launchQuery(fakeCity['address']);
                  },
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                     Text(fakeCity['address'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 14)),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Icon(Icons.location_on, size: 30, color: Color(0xffab9bd9)),

                              ),
                            ]))
                
                  ],
                ),
              )),
              Padding(
                padding:  EdgeInsets.all(10),  
                child: MarkdownBody(
                  data: fakeCity['description'],
                  extensionSet: md.ExtensionSet.gitHubWeb,
                  )),
         
          CarouselSlider(
            options: CarouselOptions(
              height: 150,
              // aspectRatio: 0.2,
              viewportFraction: 0.5,
              // initialPage: 0,
              enableInfiniteScroll: true,
              // reverse: false,
              // enlargeCenterPage: true,
              // scrollDirection: Axis.horizontal,
            ),
            items: imageGallery.map((i) {
              return  Container(
             margin: EdgeInsets.all(5.0),
             child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image(image: NetworkImage(i))
              ));
            }).toList(),
          )
        ])));
  }
}
