import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rewardstender/CloudServices/FirebaseReferences.dart';
import 'package:rewardstender/Models/ClerkUser.dart';
import 'package:rewardstender/Models/HistoryTicket.dart';
import 'package:rewardstender/Models/Costumer.dart';
import 'package:rewardstender/Models/Place.dart';
import 'package:rewardstender/Models/User.dart';
import 'package:rewardstender/Utils/Const.dart';

class MyFirebase{
  MyFirebase();
  static final ref = FirebaseDatabase.instance.reference();

  static Future getUsername(String uid){
    return FirebaseDatabase.instance.reference().child(Const.userId).child(uid).once();
  }

  static Future<Map> getClerk(String uid)async{
    DataSnapshot snap = await MyRefs.db.child(MainFields.clerks).child(uid).once();

    debugPrint("past the first herdle");
    if(snap.value!=null){
      return Map.from(snap.value);
    }else{
      return Map();
    }
  }

  static Future<Map> getUser(String uid)async{
    debugPrint("uid = " + uid);
    DataSnapshot snap = await MyRefs.getUser(uid).once();

    if(snap.value!=null){
      return Map.from(snap.value);
    }else{
      return Map();
    }
  }

  static Future getHistoryTickets(String placeId, String clerkId)async{
    DataSnapshot snap = await MyRefs.getHistoryList(placeId, clerkId).once();
    if(snap.value!=null) {
      return Map
          .from(snap.value)
          .values
          .toList();
    }else{
      return List();
    }
    }

  static Future associateUserWithPlace(User user, String placeName){
    return MyFirebase.ref
        .child(Const.costumers)
        .child(placeName)
        .child(user.userid).set({

      Const.userId: user.userid,
      Const.username : user.username,
      Const.email : user.email,
      Const.points : "0"
      
    });
  }

  void addUserToCostumersList(Costumer costumer, Place place){

    MyFirebase.ref
        .child(Const.myPlaces)
        .child(costumer.userid)
        .child(place.placeId)
        .set({
        Const.placeId:place.placeId,
        Const.placeName: place.placeName,
        Const.placeImage: place.placeImage

    });
  }
  
  static void finalizeTransaction(Costumer costumer, Clerk clerk,  HistoryTicket ticket ) {
    var now = new DateTime.now();
    print("updating User");

    MyFirebase.ref
        .child(Const.costumers)
        .child(clerk.placeName)
        .child(costumer.userid)
        .set({
      Const.email:costumer.email,
      Const.points:costumer.points,
      Const.userId:costumer.userid,
      Const.username:costumer.username

    });

    String rightNow =
        now.second.toString()
            + " " + now.minute.toString()
            + " " + now.hour.toString()
            + " " + now.day.toString()
            + " " + now.month.toString()
            + " " + now.year.toString();


    //ticket
    MyFirebase.ref
        .child(Const.historyPath)
        .child(clerk.placeName)
        .child(clerk.name)
        .child(rightNow)
        .set({

      Const.type: ticket.type,
      Const.costumerName:costumer.username,
      Const.startingPoints : ticket.startingPoints,
      Const.newPoints: ticket.newPoints,
      Const.subtotal: ticket.subTotal,
      Const.clerkName:clerk.name,
      Const.clerkId:clerk.user_id,
      Const.comments:ticket.comments,
      Const.time: rightNow

    });
  }
}