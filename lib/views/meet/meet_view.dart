import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/meet_card.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/views/widgets/loading_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/models/city_model.dart';
import 'package:carcassonne/net/meet_api.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/router.dart';

class MeetView extends StatefulWidget {
  final String id;
  final String placeId;

  MeetView({Key key, this.id, this.placeId}) : super(key: key);

  @override
  _MeetView createState() => _MeetView();
}

class _MeetView extends State<MeetView> {
  bool loading = false;
  int _currentSelection = 0;
  List<dynamic> _meets = [];

  void fetchMeet(context) async {
      if (mounted) {
      setState(() {
        loading = true;
      });
    }

    var cityModel = Provider.of<CityModel>(context, listen: false);
    var meets = await CarcassonneMeetApi.getMeetCity(cityModel.id);
    
     if (mounted) {
      setState(() {
        _meets = meets;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      await fetchMeet(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
          backgroundColor: Color(0xff101519),

          appBar: CustomAppBar(title: 'Rencontre'), body: LoadingAnnimation());
    }

    return Scaffold(
        backgroundColor: Color(0xff101519),
        appBar: CustomAppBar(title: 'Rencontre'),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              margin: EdgeInsets.only(top: 20),
              color: Colors.yellow,
            ),
             MaterialSegmentedControl(
            children: {
                0: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Text('REJOINDRE', style: TextStyle(fontSize: 12))),
                1: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Text('CREE', style: TextStyle(fontSize: 12)))
                },
          selectionIndex: _currentSelection,
          borderColor: Colors.grey,
          selectedColor: Color(0xfff6ac65),
          unselectedColor: Colors.white,
          borderRadius: 11.0,
          disabledChildren: [2],
          onSegmentChosen: (index) {
            setState(() {
              _currentSelection = index;
            });
          },
         ),
          if(_currentSelection == 0)
          Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(children: [..._meets.map((meet) {
        return MeetCard(
            meet: meet,
            onPressed: () {
              AppRouter.router.navigateTo(context, 'meet/one',
                  replace: false, transition: TransitionType.inFromRight,
                 routeSettings: RouteSettings(arguments: {
                          'meetId': meet['_id'],
                        }),
                   );
            });
      }).toList()
      ])
                    
                    ),

             if(_currentSelection == 1) 
              Container(
                    margin: EdgeInsets.all(30),
                    child: Text('Comming Soon', style: TextStyle(fontSize: 22, color: Colors.white))),
          
         ])
      
    );
  }
}

