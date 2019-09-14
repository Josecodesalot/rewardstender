import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Models/User.dart';
import 'package:rewardstender/Provider/CameraBloc.dart';
import 'package:rewardstender/Provider/UserBloc.dart';
import 'package:rewardstender/WidgetTree/HomePage.dart';
import 'package:rewardstender/WidgetTree/LoginPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
     providers: [
       ChangeNotifierProvider<UserBloc>.value(value: UserBloc()),
       ChangeNotifierProvider<CameraBloc>.value(value: CameraBloc()),
     ],
      child: MaterialApp(
        title: 'Clerk Tool',
        home: AuthPageDecider(),
      ),
    );
  }
}

class AuthPageDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return FutureBuilder(
        future: userBloc.checkStatus(),
        builder: (_, asyncSnap) {
          if (asyncSnap.connectionState == ConnectionState.waiting) {
            return Scaffold(body: CircularProgressIndicator());
          } else {
            if (userBloc.authStatus == AuthStatus.signedIn) {
              return HomePage();
            } else {
              return LoginPage();
            }
          }
        }
    );
  }
}