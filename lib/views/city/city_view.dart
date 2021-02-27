import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/router.dart';
import 'package:fluro/fluro.dart';


var fakeCitys = [
  {
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Nivelles2011.JPG/280px-Nivelles2011.JPG',
    'name': 'Nivelles',
    'description':
        'Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\'arrondissement administratif et judiciaire de Nivelles.',
    'population': 28521,
    'type': 'small',
    'countryCode': 'BR',
  },
  {
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Nivelles2011.JPG/280px-Nivelles2011.JPG',
    'name': 'Nivelles',
    'description':
        'Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\'arrondissement administratif et judiciaire de Nivelles.',
    'population': 28521,
    'type': 'small',
    'countryCode': 'BR',
  },
  {
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Nivelles2011.JPG/280px-Nivelles2011.JPG',
    'name': 'Nivelles',
    'description':
        'Nivelles (en néerlandais Nijvel, en wallon Nivele) est une ville francophone de Belgique située en Région wallonne dans la province du Brabant wallon, chef-lieu de l\'arrondissement administratif et judiciaire de Nivelles.',
    'population': 28521,
    'type': 'small',
    'countryCode': 'BR',
  },
];
Widget renderCityCard(context, city) {
  return (Container(
    height: 100,
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        border: Border.all(color: Color(0xffC4C4C4)),
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: InkWell(
        onTap: () {
          AppRouter.router.navigateTo(context, 'home', replace: true, transition: TransitionType.inFromRight);
          
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(city['image']),
                height: 100,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${city['name']} / ${city['population']} / ${city['countryCode']}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 200,
                          child: Text(
                            city['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          )),
                    ],
                  )),
            ])),
  ));
}

class CityView extends StatefulWidget {
  final bool showReminder;

  CityView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _CityViewState createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'City'),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for your city',
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              )),
          ...fakeCitys.map((city) {
            return renderCityCard(context, city);
          }).toList()
        ])));
  }
}
