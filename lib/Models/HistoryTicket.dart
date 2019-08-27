import 'ClerkUser.dart';
import 'Costumer.dart';

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
}

