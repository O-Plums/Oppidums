import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter_i18n/flutter_i18n.dart';


class PlaceCard extends StatefulWidget {
  final Map<String, dynamic> place;
  final Function onPressed;

  PlaceCard({Key key, this.place, this.onPressed}) : super(key: key);
  @override
  _PlaceCard createState() => _PlaceCard();
}

class _PlaceCard extends State<PlaceCard> {
  Color titleColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.place['type'] == 'tourism') { titleColor = Color(0xfff6ac65); }
    if (widget.place['type'] == 'history') { titleColor = Color(0xffd4c5fc); }
    if (widget.place['type'] == 'cult') { titleColor = Color(0xfffee895); }

    return Container(
        height: 250,
        width: double.infinity,
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        image: NetworkImage(widget.place['image']['url'] ??
                            'assets/image_loading.gif'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.all(10),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              decoration: BoxDecoration(
                                color: titleColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                 FlutterI18n.translate(context, "common.common_word.${widget.place['type']}"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 12)))),
                      Expanded(child: Container()),
                      Container(
                             decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: const FractionalOffset(.1, 0),
                              end: const FractionalOffset(.1, 1),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BorderedText(
                                      strokeWidth: 2,
                                      strokeColor: Colors.black,
                                      child: Text(widget.place['name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16))),
                                  Row(
                                    children: [
                                      Text(
                                          widget.place['approval']?.length
                                                  .toString() ??
                                              '0',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff8ec6f5),
                                              fontSize: 16)),
                                      Icon(Icons.favorite_border_outlined,
                                          color: Color(0xff8ec6f5)),
                                    ],
                                  ),
                                ]),
                          ),
                        
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: BorderedText(
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                            child: Text(widget.place['shortDescription'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                      ),
                      ])),
                    ],
                  ))),
        ));
  }
}
