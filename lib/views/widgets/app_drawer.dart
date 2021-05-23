import 'package:flutter/material.dart';
import 'package:carcassonne/router.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/models/city_model.dart';

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

class CustomAppDrawer extends StatefulWidget {
  final String dateToGet;
  CustomAppDrawer({Key key, this.dateToGet}) : super(key: key);
  @override
  _CustomAppDrawerState createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  String name;
  String picture;
  bool isSubscribe = false;

  Map<String, dynamic> _citie = null;



  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {

        if (mounted) {
    var cityModel = Provider.of<CityModel>(context, listen: false);

      setState(() {
          picture = cityModel.url;
          name = cityModel.name;
      });
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      Container(
        height: 125,
        child: DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xfff2f2f2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (picture != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(picture),
                    minRadius: 30,
                    maxRadius: 30,
                  ),
                if (name != null)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          CustomInkWell(
                            child: Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Voir la ville',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                )),
                            onTap: () {
                              AppRouter.router.navigateTo(context, 'city/info',
                                  replace: false,
                                  transition: TransitionType.inFromRight);
                            },
                          )
                        ],
                      ),
                    ),
                  )
              ],
            )),
      ),
      ListTile(
          onTap: () {
            print('show calendar');
            AppRouter.router.navigateTo(context, 'calendar',
                replace: false, transition: TransitionType.inFromLeft);
          },
          leading: Icon(Icons.calendar_today),
          title: Text('Calendar')),
      ListTile(
          onTap: () {
            AppRouter.router.navigateTo(context, 'city',
                replace: true, transition: TransitionType.inFromLeft);
          },
          leading: Icon(Icons.swap_calls),
          title: Text('Changer de ville')),
    ]));
  }
}
