import 'package:flutter/material.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
import 'package:rewardstender/Models/ClerkUser.dart';
import 'package:rewardstender/Utils/Const.dart';

class TransHistoryScreen extends StatefulWidget {
  @override
  _TransHistoryScreenState createState() => _TransHistoryScreenState();
}

class _TransHistoryScreenState extends State<TransHistoryScreen> {
  Clerk clerk = ClerkTools.developerCleck();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" Transaction History"),),
      body: Container(),
    );
  }

  Widget Container(){
    return FutureBuilder(
      future: MyFirebase.ref.child(Const.historyPath).child(clerk.placeName).child(clerk.name).once(),
      builder:  (_,value){

      }
    );
  }
}
