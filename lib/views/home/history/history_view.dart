import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/place_card.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/router.dart';


var fakePlace = [
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Nivelles_JPG02.jpg/220px-Nivelles_JPG02.jpg',
    'name': 'Chateaux de nivelle',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Nivelles_JPG02.jpg/220px-Nivelles_JPG02.jpg',
    'name': 'Chateaux de nivelle',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Nivelles_JPG02.jpg/220px-Nivelles_JPG02.jpg',
    'name': 'Chateaux de nivelle',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Nivelles_JPG02.jpg/220px-Nivelles_JPG02.jpg',
    'name': 'Chateaux de nivelle',
    'description':'un super chateaux fort de ouf qui tue',
  },
];

class HistoryView extends StatefulWidget {
  final bool showReminder;

  HistoryView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
     return SingleChildScrollView(
        child: Column(children: [
      ...fakePlace.map((place) {
        return PlaceCard(place: place,
           onPressed: () {
              AppRouter.router.navigateTo(context, 'place', replace: false, transition: TransitionType.inFromRight);
        }
        );
      }).toList()
    ]));
  }
}
