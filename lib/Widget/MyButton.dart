

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton(this.title);
   final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.black,
      elevation: 2,
      borderRadius: BorderRadius.circular(100.00),
      child: Container(
        color: Colors.white10,
        padding: EdgeInsets.symmetric(vertical:10,horizontal: 15),
        child: Stack(
          children: <Widget>[
            InkWell(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}

class MySelectableButton extends StatelessWidget {
  MySelectableButton(this.title, this.selected);
  final String title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    double elevation =2;
    if(selected){
      elevation=8;
    }

    return Material(
      shadowColor: Colors.black,
      elevation: elevation,
      borderRadius: BorderRadius.circular(100.00),
      child: Container(
        color: Colors.white10,
        padding: EdgeInsets.symmetric(vertical:10,horizontal: 15),
        child: Stack(
          children: <Widget>[
            InkWell(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
