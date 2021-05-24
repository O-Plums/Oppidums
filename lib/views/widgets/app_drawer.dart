import 'package:flutter/material.dart';
import 'package:carcassonne/router.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/views/widgets/app_flat_button.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/models/city_model.dart';

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
      child: Container(
        color: Color(0xff101519),
        child: Column(children: [
      Container(
        height: 125,
        child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                image: NetworkImage(picture ?? 'assets/image_loading.gif'),
                fit: BoxFit.cover),
    //  borderRadius: BorderRadius.only(
    //     bottomRight: Radius.circular(40),
    //   ),

            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (name != null)
                  Flexible(
                    child: Container(
                      
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 170,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                           CustomFlatButton(
        loadingColor: Colors.white,
        color: Colors.transparent,
        borderWidth: 2,
        borderColor: Colors.white,
        textColor: Colors.white,
        onPressed: () {
           AppRouter.router.navigateTo(context, 'city/info',
                                  replace: false,
                                  transition: TransitionType.inFromRight);
        },
        fontSize: 12,
        label: 'Voir la ville',
      ),
          
                        ],
                      ),
                    ),
                  )
              ],
            )),
      ),
      ListTile(
          onTap: () {
            AppRouter.router.navigateTo(context, 'calendar',
                replace: false, transition: TransitionType.inFromRight);
          },
          leading: Icon(Icons.calendar_today, color: Color(0xfff6ac65)),
          title: Text('Calendar', style: TextStyle(color: Colors.white))),
          ListTile(
          onTap: () {
            AppRouter.router.navigateTo(context, 'meet',
                replace: false, transition: TransitionType.inFromRight);
          },
          leading: Icon(Icons.people, color: Color(0xfff6ac65)),
          title: Text('Rencontre', style: TextStyle(color: Colors.white))),
      Expanded(child: Container()),
      Divider(),
      ListTile(
          onTap: () {
            AppRouter.router.navigateTo(context, 'city',
                replace: true, transition: TransitionType.inFromLeft);
          },
          leading: Icon(Icons.swap_calls, color: Color(0xfff6ac65)),
          title: Text('Changer de ville', style: TextStyle(color: Colors.white))),
    ])));
  }
}
