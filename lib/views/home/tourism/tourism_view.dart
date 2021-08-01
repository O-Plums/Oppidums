import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/place_card.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidums/net/place_api.dart';
import 'package:oppidums/views/widgets/loading_widget.dart';
import 'package:oppidums/router.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';


class TourismeView extends StatefulWidget {
  final bool showReminder;

  TourismeView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _TourismeViewState createState() => _TourismeViewState();
}

class _TourismeViewState extends State<TourismeView> {
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
        await OppidumsPlaceApi.getPlaceByType('tourism', cityModel.id);
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
        await OppidumsPlaceApi.getPlaceByType('tourism', cityModel.id);
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
            }).toList()
          ])))
    ]);
  }
}
