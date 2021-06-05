import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:oppidum/views/widgets/app_inkwell.dart';
import 'package:lottie/lottie.dart';

class PlaceCard extends StatefulWidget {
  final Map<String, dynamic> place;
  final Function onPressed;

  PlaceCard({Key key, this.place, this.onPressed}) : super(key: key);
  @override
  _PlaceCard createState() => _PlaceCard();
}

class _PlaceCard extends State<PlaceCard>{


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        child: InkWell(
          onTap:widget.onPressed,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.dstATop),
                        image: NetworkImage(widget.place['image']['url'] ??
                            'assets/image_loading.gif'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                
                      Expanded(child: Container()),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.place['name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16)),
                              Row(
                                children: [
                                  Text(
                                      widget.place['approval']?.length.toString() ?? '0',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff6ac65),
                                          fontSize: 16)),
                                  Icon(Icons.favorite_border_outlined, color: Color(0xfff6ac65)),
                                ],
                              ),
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child:
                         Text(widget.place['shortDescription'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                    ),
                    ],
                  ))),
        ));
  }
}
