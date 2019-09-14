

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
