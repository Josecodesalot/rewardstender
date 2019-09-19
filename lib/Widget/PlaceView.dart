import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rewardstender/Utils/Const.dart';

import 'MyButton.dart';

class PlaceView extends StatelessWidget {
  final Map place;
  final String type;
  final String message="?";
  PlaceView(this.place, this.type);

  static  TextStyle titleStyle(){
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16
    );
  }

  static TextStyle contentStyle(){
    return TextStyle(
      color: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("PlaceView called place = " + place.toString());

    return FlipCard(
        front: Card(
          color: Colors.black,
          child: FittedBox(
            child: CachedNetworkImage(
              imageUrl: place[PlaceRequestField.urlPic],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        back:
          Card(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    width: double.infinity,
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(place[PlaceRequestField.name], style: titleStyle(),overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                descriptionList(),

                GestureDetector(
                  onTap: (){onClick(context);},
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: MyButton(message),
                    ),
                ),
              ],
            ),
          )

    );
  }

  void onClick(BuildContext context){

  }

  Widget descriptionList(){
    return Expanded(
      child: ListView(
        children: <Widget>[

          Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(place[PlaceRequestField.descritpion],style: contentStyle(),),
            ),
          ),
          SizedBox(height: 32,),
        ],
      ),
    );
  }

  Gradient buttonGradient(){
    return LinearGradient(
        colors: <Color>[Colors.pinkAccent, Colors.deepOrange]
    );
  }

  Widget stuff(){
    return Column(
      children: <Widget>[
        Text(place[PlaceRequestField.name]),
        Text(place[PlaceRequestField.website]),
        Text(place[PlaceRequestField.location]),
        Text(place[PlaceRequestField.descritpion]),
        Text(place[PlaceRequestField.phoneNumber]),
      ],
    );
  }
}
  