import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';

var fakeCity = {
  'image':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Nivelles2011.JPG/280px-Nivelles2011.JPG',
  'name': 'Nivelles',
  'description':
      'Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\'arrondissement administratif et judiciaire de Nivelles.',
  'population': 28521,
  'type': 'small',
  'countryCode': 'BR',
};

class CityInfoView extends StatefulWidget {
  final String id;

  CityInfoView({Key key, this.id }) : super(key: key);

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
                    Text(fakeCity['population'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
              child: Text(
                fakeCity['description'],
                style: TextStyle(fontSize: 14),
              )),
        ])));
  }
}
