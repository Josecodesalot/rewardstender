// Created By Jose Ignacio Lara Arandia 2019/09/16/time:15:56

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Provider/TicketProvider.dart';
import 'package:rewardstender/Utils/Const.dart';
import 'package:rewardstender/WidgetTree/HistoryTicketCalendar.dart';
import 'package:rewardstender/services/FirebaseMethod.dart';
import 'package:rewardstender/view_model/auth_model.dart';

class HistoryTicketsPage extends StatelessWidget {
  AuthModel userBloc;
  TicketProvider ticketProvider;

  @override
  Widget build(BuildContext context) {
    debugPrint("HistoryTicketsPageCalled");
    userBloc= Provider.of<AuthModel>(context);
    ticketProvider = Provider.of<TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text("Tickets From " + ticketProvider.date),
      ),
      body: _getTickets(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_today),
        tooltip: "Get tickets by date",

        onPressed: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryTicketsCalendar()));
        },
      ),
    );
  }

  Widget _getTickets(){
    return FutureBuilder(
      future: MyFirebase.getTickets(userBloc.clientState.user.uid, ticketProvider.date),
      builder: (context, asyncSnap){
      if(asyncSnap.connectionState==ConnectionState.waiting){
        return CircularProgressIndicator();
      }else{
        if(asyncSnap.data!=null){
          List tickets = asyncSnap.data;
          if(tickets.isNotEmpty){
              return ticketView(tickets);

          }else{
            return Text("No Tickets");
          }
        }else{
          return Text("asyncNUll");
        }
      }
      }
    );
  }

  Widget ticketView(List tickets){
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, i){
        return GestureDetector(
          onTap: (){_ticketOptions(context, tickets[i]);},
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(tickets[i][HistoryTicketFields.clerkName]),
                Text(tickets[i][HistoryTicketFields.guestName]),
                Text(tickets[i][HistoryTicketFields.startingPoints].toString()),
                Text(tickets[i][HistoryTicketFields.awardingPoints].toString()),
                Text(tickets[i][HistoryTicketFields.endingPoints].toString()),
                Text(tickets[i][HistoryTicketFields.time].toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  _ticketOptions(BuildContext context, Map ht){
    final  controller = TextEditingController();
    String message;
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Create Message "),
          content: Container(
            height: MediaQuery.of(context).size.height/2,
            child: Column(
              children: <Widget>[
                Spacer(),
                TextField(
                  autofocus: true,
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 4,
                  controller: controller,
                  maxLength: 150,
                ),
                Spacer(),
                RaisedButton(
                  child: Text("Add Comment to history" ,style: Style.whiteTxt(), ),
                  onPressed: ()async{
                    message =controller.text;
                    ht[HistoryTicketFields.comments] = message;

                    await MyFirebase.addCommentToHistory(ht, ticketProvider.date);
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text("Notify Issue To Manager" ,style: Style.whiteTxt(),),
                  onPressed: ()async{
                    message =controller.text;
                    ht[HistoryTicketFields.comments] = message;
                    debugPrint("ht = " + ht.toString());
                    await MyFirebase.createIssue(ht, ticketProvider.date);
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text("Cancel",style: Style.whiteTxt(),),
                )
              ],
            ),
          ),
          actions: <Widget>[

          ],
        );
      }
    );
}

}


class Style{
  static TextStyle whiteTxt(){
    return TextStyle(
      color: Colors.white,
    );
}
}