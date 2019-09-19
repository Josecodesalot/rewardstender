// Created By Jose Ignacio Lara Arandia 2019/09/17/time:04:47

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Provider/TicketProvider.dart';
import 'package:rewardstender/WidgetTree/HistoryTicketsPage.dart';

class HistoryTicketsCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("HistorTicketsCalendar called");
    TicketProvider ticketProvider= Provider.of<TicketProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("History Calendar"),),
      body: CalendarCarousel(
        onDayPressed: (dateTime, listTime){
          String date = DateFormat("dd-MM-yyyy").format(dateTime);
          debugPrint("date = " + date);
          ticketProvider.setDate(date);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryTicketsPage()));
        },
      ),
    );
  }
}
