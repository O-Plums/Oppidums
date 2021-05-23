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
     borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40),
      ),

            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (picture != null)
                //   CircleAvatar(
                //     backgroundImage: NetworkImage(picture),
                //     minRadius: 30,
                //     maxRadius: 30,
                //   ),
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
                                
                                // fontWeight: FontWeight.bold,
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
                          // CustomInkWell(
                          //   child: Padding(
                          //       padding: EdgeInsets.only(top: 5),
                          //       child: Text(
                          //         'Voir la ville',
                          //         overflow: TextOverflow.ellipsis,
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 14,
                          //         ),
                          //       )),
                          //   onTap: () {
                          //     AppRouter.router.navigateTo(context, 'city/info',
                          //         replace: false,
                          //         transition: TransitionType.inFromRight);
                          //   },
                          // )
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
      Expanded(child: Container()),
      Divider(),
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
