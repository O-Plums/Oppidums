import 'dart:convert';
import 'package:carcassonne/models/city_model.dart';
import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bottom_navigation_action.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/router.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/net/city_api.dart';
import 'package:carcassonne/views/widgets/loading_widget.dart';
import 'package:carcassonne/views/city/widgets/add_city_widget.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

Widget renderCityCard(context, city) {
  return (Container(
    height: 150,
    // margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black,
      image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.7), BlendMode.dstATop),
          image:
              NetworkImage(city['image']['url'] ?? 'assets/image_loading.gif'),
          fit: BoxFit.cover),
    ),

    child: InkWell(
        onTap: () {
          var cityModel = Provider.of<CityModel>(context, listen: false);
          cityModel.setCityBasicInfo(
              city['_id'], city['image']['url'], city['name']);
          AppRouter.router.navigateTo(context, 'home',
              replace: true, transition: TransitionType.inFromRight);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 300,
                          child: Text(
                            '${city['name']} (${city['countryCode']})',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                      Container(
                          width: 300,
                          child: Text(
                            city['shortDescription'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          )),
                      Text('Population: ${city['population']}',
                          style: TextStyle(fontSize: 12, color: Colors.white))
                    ],
                  )),
            ])),
  ));
}

class CityView extends StatefulWidget {
  final String id;

  CityView({Key key, this.id}) : super(key: key);

  @override
  _CityViewState createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {
  SearchBar searchBar;
  String searchName = '';
  List<dynamic> _allCity = null;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Color(0xff101519),
        title: new Text('Trouver une ville'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() {
      searchName = value;
      _allCity = null;
    });
    fetchCities();
  }

  void fetchCities() async {
    var data = await CarcassonneCityApi.getAllCity(searchName);

    if (mounted) {
      setState(() {
        _allCity = data;
      });
    }
  }

  Future<String> refetchCities() async {
    var data = await CarcassonneCityApi.getAllCity(searchName);

    if (mounted) {
      setState(() {
        _allCity = data;
      });
      return 'success';
    }
    return 'success';
  }

  _CityViewState() {
    searchBar = new SearchBar(
        inBar: false,
        closeOnSubmit: false,
        clearOnSubmit: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: onSubmitted,
        onCleared: () {
           setState(() {
            searchName = '';
            _allCity = null;
          });
          fetchCities();
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () {
      fetchCities();
    });
    super.initState();
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Demande reçue", style: TextStyle(color: Colors.white)),
          content: Text(
              "Merci pour votre demande, nous vous contacterons dans le plus rapidement possible.",
              style: TextStyle(color: Colors.white)),
          actions: [
            FlatButton(
              child: Text("OK", style: TextStyle(color: Color(0xfff6ac65))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          backgroundColor: Color(0xff101519),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff101519),
        appBar: searchBar.build(context),
        bottomNavigationBar: AppBottomNavigationAction(
            title: 'Ajouter ma ville',
            loading: false,
            onPressed: () {
              showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                expand: false,
                builder: (context) => AddCityWidget(
                  onValidate: () {
                    _showDialog(context);
                  },
                ),
              );
            }),
        body: RefreshIndicator(
            onRefresh: () {
              return refetchCities();
            },
            child: SingleChildScrollView(
                child: Column(children: [
              if (_allCity == null) LoadingAnnimation(),
              if (_allCity != null && _allCity.length == 0)
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50),
                    child: Text('No data',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18))),
              if (_allCity != null && _allCity.length > 0)
                ..._allCity.map((city) {
                  return renderCityCard(context, city);
                }).toList()
            ]))));
  }
}
