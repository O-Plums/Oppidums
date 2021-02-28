import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';

var fakeCity = {

  'image': 'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/p720x720/1265609_630689910312187_248089795_o.jpg?_nc_cat=102&ccb=3&_nc_sid=e3f864&_nc_ohc=sNgKN3l_c1QAX9j31oR&_nc_ht=scontent-cdg2-1.xx&tp=6&oh=b838fa5557e764da95b5fa6a272488ad&oe=605D231E',
  'name': 'Snack Le Delissimo',
  'description':'Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\'arrondissement administratif et judiciaire de Nivelles.'
};

class PlaceView extends StatefulWidget {
  final String id;
  PlaceView({ Key key, this.id }) : super(key: key);
  @override
  _PlaceViewViewState createState() => _PlaceViewViewState();
}

class _PlaceViewViewState extends State<PlaceView> {
  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      //TODO mon applle a la base de donner
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Place'),
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
                            fontSize: 22))]))),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
              child: Text(
                fakeCity['description'],
                style: TextStyle(fontSize: 14),
              )),
   
        ])));
  }
}
