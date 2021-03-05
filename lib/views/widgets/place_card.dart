import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;
  final Function onPressed;
  
  PlaceCard({this.place, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: double.infinity,
        
        child: InkWell(
          onTap: onPressed,
          child: Container(
              decoration: BoxDecoration(
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
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              // elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(place['image']), fit: BoxFit.cover),
                    ),
                    alignment: Alignment.bottomCenter,
                    height: 170,
                    child:null
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(place['name'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18)
                      ),
                      Row(children: [
                      Text(place['numberOfApproval']['\$numberInt'].toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffab9bd9),
                      fontSize: 18)
                      ),
                      Icon(Icons.star, color: Color(0xffab9bd9)),
                      ],)
                      ]
                      ),
                      
                      ),
                   Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),  
                     child: Text(place['shortDescription'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14)),
                   )],
              )),
        ));
  }
}

// decoration: BoxDecoration(
//                   image: DecorationImage(
//                       alignment: Alignment(-.2, 0),
//                       image: NetworkImage(place['image']),
//                       fit: BoxFit.cover),
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Container(
//                       decoration: new BoxDecoration(
//                         gradient: new LinearGradient(
//                             colors: [Colors.transparent, Colors.black],
//                             begin: const FractionalOffset(.1, .4),
//                             end: const FractionalOffset(.1, 1),
//                             stops: [0.0, 1.0],
//                             tileMode: TileMode.clamp),
//                       ),
//                       padding: EdgeInsets.only(bottom: 10),
//                     ),
//                     Positioned(
//                         bottom: 15,
//                         left: 5,
//                         right: 5,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(place['name'],
//                                 textAlign: TextAlign.center,

//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontSize: 20)),
//                             Text(place['description'],
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 15)),
//                           ],
//                         ))
//                   ],
//                 ),
