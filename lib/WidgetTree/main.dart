import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Provider/CameraBloc.dart';
import 'package:rewardstender/Provider/TicketProvider.dart';
import 'package:rewardstender/Provider/UserBloc.dart';
import 'package:rewardstender/WidgetTree/LoginPage.dart';
import 'Index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("MyApp Called");
    return MultiProvider(
     providers: [
       ChangeNotifierProvider<UserBloc>.value(value: UserBloc()),
       ChangeNotifierProvider<CameraBloc>.value(value: CameraBloc()),
       ChangeNotifierProvider<TicketProvider>.value(value: TicketProvider()),

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
    debugPrint("AuthPageDeciderCalled");
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    return FutureBuilder(
        future: userBloc.checkStatus(),
        builder: (_, asyncSnap) {
          if (asyncSnap.connectionState == ConnectionState.waiting) {
            return Scaffold(body: CircularProgressIndicator());
          } else {
            if (userBloc.authStatus == AuthStatus.signedIn) {
              return Index();
            } else {
              return LoginPage();
            }
          }
        }
    );
  }
}