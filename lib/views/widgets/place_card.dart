import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;

  PlaceCard({this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 230,
        child: InkWell(
          onTap: ()  { print('toto'); },
          child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment(-.2, 0),
                      image: NetworkImage(place['image']),
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: const FractionalOffset(.1, .4),
                            end: const FractionalOffset(.1, 1),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    Positioned(
                        bottom: 15,
                        left: 5,
                        right: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(place['name'],
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20)),
                            Text(place['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          ],
                        ))
                  ],
                ),
              )),
        ));
  }
}