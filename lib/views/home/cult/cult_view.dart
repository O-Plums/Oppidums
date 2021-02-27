import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/place_card.dart';


var fakePlace = [
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Chard_and_Cheese_Tart.jpg/170px-Chard_and_Cheese_Tart.jpg',
    'name': 'Tarte al d\'jote',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Chard_and_Cheese_Tart.jpg/170px-Chard_and_Cheese_Tart.jpg',
    'name': 'Tarte al d\'jote',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Chard_and_Cheese_Tart.jpg/170px-Chard_and_Cheese_Tart.jpg',
    'name': 'Tarte al d\'jote',
    'description':'un super chateaux fort de ouf qui tue',
  },
  {
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Chard_and_Cheese_Tart.jpg/170px-Chard_and_Cheese_Tart.jpg',
    'name': 'Tarte al d\'jote',
    'description':'un super chateaux fort de ouf qui tue',
  },
];

class CultView extends StatefulWidget {
  final bool showReminder;

  CultView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _CultViewState createState() => _CultViewState();
}

class _CultViewState extends State<CultView> {


  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
     return SingleChildScrollView(
        child: Column(children: [
      ...fakePlace.map((place) {
        return PlaceCard(place: place);
      }).toList()
    ]));
  }
}
