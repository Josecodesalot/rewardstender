
import 'package:flutter/material.dart';
import 'package:rewardstender/Utils/Const.dart';

import 'ClerkUser.dart';

class HistoryTicket{
  String from, placeId, key, type, guestId, guestName, startingPoints, awardingPoints, endingPoints, subTotal, clerkName, clerkId, comments, time;
  HistoryTicket(this.from, this.placeId, this.key,this.type, this.guestId,this.guestName, this.startingPoints,this.awardingPoints,this.endingPoints,this.subTotal,this.clerkName,this.clerkId,this.comments, this.time);

  @override
  String toString() {
    return 'HistoryTicket{, costumer: $guestName, startingPoints: $startingPoints, newPoints: $awardingPoints, subTotal: $subTotal, clerkName: $clerkName, clerkID: $clerkId, comments: $comments, time:$time}';
  }
}

class HistoryTicketTools{
  static  HistoryTicket getNonNullHistoryTicket (){
    return HistoryTicket(
  "", "", "","","","","","","","","","","","Comments not enabled yet",
    );
  }

  static Map toMap(HistoryTicket historyTicket){
    Map ticketMap=Map();

    ticketMap[HistoryTicketFields.placeId]=historyTicket.placeId;
    ticketMap[HistoryTicketFields.key]=historyTicket.key;
    ticketMap[HistoryTicketFields.type]=historyTicket.type;
    ticketMap[HistoryTicketFields.guestId]=historyTicket.guestId;
    ticketMap[HistoryTicketFields.guestName]=historyTicket.guestName;
    ticketMap[HistoryTicketFields.startingPoints]=historyTicket.startingPoints;
    ticketMap[HistoryTicketFields.awardingPoints]=historyTicket.awardingPoints;
    ticketMap[HistoryTicketFields.endingPoints]=historyTicket.endingPoints;
    ticketMap[HistoryTicketFields.subTotal]=historyTicket.subTotal;
    ticketMap[HistoryTicketFields.clerkName]=historyTicket.clerkName;
    ticketMap[HistoryTicketFields.clerkId]=historyTicket.clerkId;
    ticketMap[HistoryTicketFields.comments]=historyTicket.comments;
    ticketMap[HistoryTicketFields.time]=historyTicket.time;

    return ticketMap;
  }

  static toObj(Map ticketMap){
    HistoryTicket historyTicket = getNonNullHistoryTicket();
    debugPrint("history ticket ot null  = " + historyTicket.toString());
    historyTicket.key =ticketMap[HistoryTicketFields.key];
    historyTicket.placeId =ticketMap[HistoryTicketFields.placeId];
    historyTicket.type =ticketMap[HistoryTicketFields.type];
    historyTicket.guestId =ticketMap[HistoryTicketFields.guestId];
    historyTicket.guestName = ticketMap[HistoryTicketFields.guestName];
    historyTicket.startingPoints = ticketMap[HistoryTicketFields.startingPoints];
    historyTicket.awardingPoints = ticketMap[HistoryTicketFields.awardingPoints];
    historyTicket.endingPoints = ticketMap[HistoryTicketFields.endingPoints];
    historyTicket.subTotal = ticketMap[HistoryTicketFields.subTotal];
    historyTicket.clerkName = ticketMap[HistoryTicketFields.clerkName];
    historyTicket.clerkId  =ticketMap[HistoryTicketFields.clerkId];
    historyTicket.comments = ticketMap[HistoryTicketFields.comments];
    historyTicket.time = ticketMap[HistoryTicketFields.time];

  }

  static HistoryTicket initWithClerk(Clerk clerk){
    return HistoryTicket ("","",
     "",  "","", "","","","","",clerk.name,clerk.user_id,"Comments not enabled yet",""
    );
  }
}

class GuestTicket{
  String ticketId;
}
class TicketGuest{
  String ticketId;
}

class GuestHistoryTicketFields{
  static final String id = "id";
}
class TicketGuestFields{
  static final String id="id";
}


