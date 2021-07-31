import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/place_card.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidum/net/place_api.dart';
import 'package:oppidum/views/widgets/loading_widget.dart';
import 'package:oppidum/router.dart';
import 'package:oppidum/models/city_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidum/views/widgets/app_bottom_navigation_action.dart';



class AllPlaces extends StatefulWidget {
  final bool showReminder;

  AllPlaces({Key key, this.showReminder = false}) : super(key: key);

  @override
  _TourismeViewState createState() => _TourismeViewState();
}

class _TourismeViewState extends State<AllPlaces> {
  bool loading = false;
  List<dynamic> _places = [];

  void fetchPlace(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var cityModel = Provider.of<CityModel>(context, listen: false);

    var places =
        await OppidumPlaceApi.getAllPlaceOfCity(cityModel.id);
    if (mounted) {
      setState(() {
        _places = places;
        loading = false;
      });
    }
  }
  Future<String>  refetchPlace(context) async {
    var cityModel = Provider.of<CityModel>(context, listen: false);

    var places =
        await OppidumPlaceApi.getAllPlaceOfCity(cityModel.id);
    if (mounted) {
      setState(() {
        _places = places;
      });
      return 'success';
    }
      return 'success';

  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () {
       fetchPlace(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          decoration: new BoxDecoration(
        color: Color(0xff101519),
      )),
      RefreshIndicator(
          onRefresh: () {
           return refetchPlace(context);
          },
          child: SingleChildScrollView(
              child: Column(children: [
            if (loading == true) LoadingAnnimation(),
            if (_places.length == 0 && loading == false)
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 50),
                  child: Text(FlutterI18n.translate(context, "common.common_word.noData"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18))),
            ..._places.map((place) {
              return PlaceCard(
                  place: place,
                  onPressed: () {
                    AppRouter.router.navigateTo(
                      context,
                      'place',
                      replace: false,
                      transition: TransitionType.inFromRight,
                      routeSettings: RouteSettings(arguments: {
                        'placeId': place['_id'],
                      }),
                    );
                  });
            }).toList(),
               if (loading == false)
              AppBottomNavigationAction(
            title: FlutterI18n.translate(context, "common.app_drawer.changeCity"),
            loading: false,
            onPressed: () {
              AppRouter.router.navigateTo(context, 'city',
                        replace: true, transition: TransitionType.inFromLeft);
            })
          ]))),

        
    ]);
  }
}
