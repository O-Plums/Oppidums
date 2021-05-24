import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MeetCard extends StatelessWidget {
  final Map<String, dynamic> meet;
  final Function onPressed;
  
  MeetCard({this.meet, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
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
    
              child: 
              
              Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                image: NetworkImage(meet['place']['image']['url'] ?? 'assets/image_loading.gif'),
                fit: BoxFit.cover),

            ),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: Container()),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: NetworkImage(meet['image']['url']), fit: BoxFit.cover),
                  //   ),
                  //   alignment: Alignment.bottomCenter,
                  //   height: 170,
                  //   child:null
                  // ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(meet['title'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18)
                      ),
                      Row(children: [
                      Text(meet['participens'].length.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff6ac65),
                      fontSize: 18)
                      ),
                      Icon(Icons.star, color: Color(0xfff6ac65)),
                      ],)
                      ]
                      ),
                      
                      ),
                   Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),  
                     child: Text(meet['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                   ),
                  Divider()
              
                   ],
              ))),
        ));
  }
}