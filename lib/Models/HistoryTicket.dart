import 'package:firebase_database/firebase_database.dart';
import 'package:rewardstender/Utils/Const.dart';

import 'ClerkUser.dart';

class HistoryTicket{
  String type, costumer, startingPoints, newPoints, subTotal, clerkName, clerkID, comments, time;
  HistoryTicket( this.type, this.costumer, this.startingPoints,this.newPoints,this.subTotal,this.clerkName,this.clerkID,this.comments, this.time);

  @override
  String toString() {
    return 'HistoryTicket{type: $type, costumer: $costumer, startingPoints: $startingPoints, newPoints: $newPoints, subTotal: $subTotal, clerkName: $clerkName, clerkID: $clerkID, comments: $comments, time:$time}';
  }
}

class TicketTools{
  static  HistoryTicket getNonNullHistoryTicket (){
    return HistoryTicket(
    "","","","","","","","Comments not enabled yet", ""
    );
  }

  static HistoryTicket initWithClerk(Clerk clerk){
    return HistoryTicket (
        "","","","","",clerk.name,clerk.user_id,"Comments not enabled yet",""
    );
  }
  List<HistoryTicket> placesFromSnapShot(DataSnapshot snap){
    List<HistoryTicket> places = new List();
    Map map = new Map<String, dynamic>.from(snap.value);
    List<String> keys =  map.keys.toList();

    for (int i=0; i< map.length;i++){
      places.add(
          new HistoryTicket(
            map[keys[i]][Const.type],
            map[keys[i]][Const.costumerName],
            map[keys[i]][Const.startingPoints],
            map[keys[i]][Const.startingPoints],
            map[keys[i]][Const.newPoints],
            map[keys[i]][Const.subtotal],
            map[keys[i]][Const.clerkName],
            map[keys[i]][Const.clerkId],
            map[keys[i]][Const.time],
          ));}

    print(places.toString());
    return places;
  }
}

