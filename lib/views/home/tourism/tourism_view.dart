import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/place_card.dart';
import 'package:fluro/fluro.dart';
import 'package:carcassonne/router.dart';

var fakePlace = [
  {
    'image':
        'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/p720x720/1265609_630689910312187_248089795_o.jpg?_nc_cat=102&ccb=3&_nc_sid=e3f864&_nc_ohc=sNgKN3l_c1QAX9j31oR&_nc_ht=scontent-cdg2-1.xx&tp=6&oh=b838fa5557e764da95b5fa6a272488ad&oe=605D231E',
    'name': 'Snack Le Delissimo',
    'numberOfApproval': 10,
    'description':
        'Le Delissimo est toujours à votre écoute , pour tous vos commentaires , suggestions , remarques ou demandes , veuillez nous contacter via le formulaire suivant',
  },
  {
    'image':
        'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/p720x720/1265609_630689910312187_248089795_o.jpg?_nc_cat=102&ccb=3&_nc_sid=e3f864&_nc_ohc=sNgKN3l_c1QAX9j31oR&_nc_ht=scontent-cdg2-1.xx&tp=6&oh=b838fa5557e764da95b5fa6a272488ad&oe=605D231E',
    'numberOfApproval': 30,
    'name': 'Snack Le Delissimo',
    'description':
        'Le Delissimo est toujours à votre écoute , pour tous vos commentaires , suggestions , remarques ou demandes , veuillez nous contacter via le formulaire suivant',
  },
  {
    'image':
        'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/p720x720/1265609_630689910312187_248089795_o.jpg?_nc_cat=102&ccb=3&_nc_sid=e3f864&_nc_ohc=sNgKN3l_c1QAX9j31oR&_nc_ht=scontent-cdg2-1.xx&tp=6&oh=b838fa5557e764da95b5fa6a272488ad&oe=605D231E',
    'numberOfApproval': 530,
    'name': 'Snack Le Delissimo',
    'description':
        'Le Delissimo est toujours à votre écoute , pour tous vos commentaires , suggestions , remarques ou demandes , veuillez nous contacter via le formulaire suivant',
  },
  {
    'image':
        'https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/p720x720/1265609_630689910312187_248089795_o.jpg?_nc_cat=102&ccb=3&_nc_sid=e3f864&_nc_ohc=sNgKN3l_c1QAX9j31oR&_nc_ht=scontent-cdg2-1.xx&tp=6&oh=b838fa5557e764da95b5fa6a272488ad&oe=605D231E',
    'numberOfApproval': 1,
    'name': 'Snack Le Delissimo',
    'description':
        'Le Delissimo est toujours à votre écoute , pour tous vos commentaires , suggestions , remarques ou demandes , veuillez nous contacter via le formulaire suivant',
  },
];

class TourismeView extends StatefulWidget {
  final bool showReminder;

  TourismeView({Key key, this.showReminder = false}) : super(key: key);

  @override
  _TourismeViewState createState() => _TourismeViewState();
}

class _TourismeViewState extends State<TourismeView> {
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
