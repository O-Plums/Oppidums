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


Widget renderCityCard(context, city) {
  return (Container(
    height: 100,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      // border: Border.all(color: Color(0xffC4C4C4)),
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 2,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: InkWell(
        onTap: () {
        var cityModel = Provider.of<CityModel>(context, listen: false);

          cityModel.setCityId(city['_id']['\$oid']);
          AppRouter.router.navigateTo(context, 'home',
              replace: true, transition: TransitionType.inFromRight);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Image(
                    image: NetworkImage(city['image']),
                    height: 95,
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${city['name']} (${city['countryCode']})',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          width: 170,
                          child: Text(
                            city['shortDescription'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          )),
                      Text('Population: ${city['population']['\$numberInt']}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600))
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
  List<dynamic> _allCity = [];

  void fetchCities() async {
    var data = await CarcassonneCityApi.getAllCity();
    print(data['cities']);
    if (mounted) {
      setState(() {
        _allCity = data['cities'];
      });
    }
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
          title: Text("Demande ressu"),
          content: Text("Merci pour votre demande, on vous fait un retour dans les plus bref delai"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'City'),
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
        body: SingleChildScrollView(
            child: Column(children: [
          if (_allCity.length == 0) LoadingAnnimation(),
          ..._allCity.map((city) {
            return renderCityCard(context, city);
          }).toList()

        ])));
  }
}
