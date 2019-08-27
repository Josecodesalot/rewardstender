import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:rewardstender/Utils/AuthProvider.dart';
import 'package:rewardstender/WidgetTree/RootPage.dart';
import 'package:rewardstender/Utils/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}