// Created By Jose Ignacio Lara Arandia 2019/09/14/time:03:22

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
import 'package:rewardstender/CloudServices/FirebaseReferences.dart';
import 'package:rewardstender/Models/PlaceGuest.dart';
import 'package:rewardstender/Utils/Const.dart';


class GetGuestFuture{

  static Future getData(String uid, String placeId) async{
    Map data = Map();
    DataSnapshot snapshot;

    debugPrint("guestId = $uid place id = $placeId");
    DatabaseReference ref=MyRefs.db.child(MainFields.placeGuests).child(placeId).child(uid);
    //This snapshot gets data from a user associated with a place
    debugPrint("ref = " + ref.key.toString());
    snapshot = await ref.once();

    if(snapshot.value!=null) {
      debugPrint("Guest Associated with place already");
      Map placeGuest = Map.from(snapshot.value);
      data[GuestFutureFields.getGuestMap]=placeGuest;
      data[GuestFutureFields.newUsernbool]=false;
      return data;

    } else{
      debugPrint("Guest Not asscoiated with place");
      Map guest = await MyFirebase.getGuest(uid);
      if(guest.isNotEmpty){
        debugPrint("guest not empty");
        Map placeGuest=Map();
        placeGuest[PlaceGuestFields.points]=0;
        placeGuest[PlaceGuestFields.guestId]= guest[GuestFields.userId];
        placeGuest[PlaceGuestFields.guestName] = guest[GuestFields.name];
        data[GuestFutureFields.getGuestMap]=placeGuest;
        data[GuestFutureFields.newUsernbool]=true;
        debugPrint("placeGuest id " +  placeGuest[PlaceGuestFields.guestId].toString());
        return data;
      }else{
        debugPrint("Error person not found");
        return Map();
      }
    }
  }
}

class GuestFutureFields{
  static final String getGuestMap = "mainMap";
  static final String newUsernbool = "newUserBool";
}

