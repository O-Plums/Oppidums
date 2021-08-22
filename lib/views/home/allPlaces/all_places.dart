import 'package:flutter/material.dart';
import 'package:oppidums/views/widgets/place_card.dart';
import 'package:fluro/fluro.dart';
import 'package:oppidums/net/place_api.dart';
import 'package:oppidums/views/widgets/loading_widget.dart';
import 'package:oppidums/router.dart';
import 'package:oppidums/models/city_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:oppidums/views/widgets/app_bottom_navigation_action.dart';
import 'package:oppidums/views/widgets/filter_widget.dart';

class AllPlaces extends StatefulWidget {
  final bool showReminder;

  AllPlaces({Key key, this.showReminder = false}) : super(key: key);

  @override
  _AllPlacesViewState createState() => _AllPlacesViewState();
}

class _AllPlacesViewState extends State<AllPlaces> {
  bool loading = false;
  int _selectedFilterIndex = 0;
  List<dynamic> _places = [];
  List<Map<String, dynamic>> _filters = [
    {'label': 'common.common_word.all'},
    {'label': 'common.common_word.tourism'},
    {'label': 'common.common_word.history'},
    {'label': 'common.common_word.cult'},
  ];

  void fetchPlace(context) async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      var cityModel = Provider.of<CityModel>(context, listen: false);

      var places = await OppidumsPlaceApi.getAllPlaceOfCity(cityModel.id);
      if (mounted) {
        setState(() {
          _places = places;
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleFilter(int index, context) async {
    try {
      String type = '';
      if (index == _selectedFilterIndex) {
        return;
      }
      if (mounted) {
        setState(() {
          loading = true;
          _places = [];
        });
      }

      if (index == 0) {
        await fetchPlace(context);
        return;
      }
      if (index == 1) {
        type = 'tourism';
      }
      if (index == 2) {
        type = 'history';
      }
      if (index == 3) {
        type = 'cult';
      }
      var cityModel = Provider.of<CityModel>(context, listen: false);
      var places = await OppidumsPlaceApi.getPlaceByType(type, cityModel.id);

      if (mounted) {
        setState(() {
          _places = places;
          _selectedFilterIndex = index;
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> refetchPlace(context) async {
    var cityModel = Provider.of<CityModel>(context, listen: false);

    var places = await OppidumsPlaceApi.getAllPlaceOfCity(cityModel.id);
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
            WidgetFilters(
                filters: _filters,
                onFilterSelected: (int index) {
                  _handleFilter(index, context);
                }),
            if (loading == true) LoadingAnnimation(),
            if (_places.length == 0 && loading == false)
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 50),
                  child: Text(FlutterI18n.translate(context, "common.common_word.noData"),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18))),
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
                    AppRouter.router.navigateTo(context, 'city', replace: true, transition: TransitionType.inFromLeft);
                  })
          ]))),
    ]);
  }
}
