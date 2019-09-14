import 'package:flutter/material.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';

class TransHistory extends StatefulWidget {
  TransHistory(this.placeId, this.clerkId);
  String placeId, clerkId;
  @override
  _TransHistoryState createState() => _TransHistoryState();
}

class _TransHistoryState extends State<TransHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History"),),
      body: getHistory(),
    );
  }

  Widget getHistory(){

    return FutureBuilder(
          future: MyFirebase.getHistoryTickets(widget.placeId, widget.clerkId) ,
          builder: (context, asyncSnap){
            if(asyncSnap.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
            }else{
              if(asyncSnap.data!=null){
                return Text("data is not null");
              }else{
                return Text("data is null");
              }
            }
          },
        );
  }
}
