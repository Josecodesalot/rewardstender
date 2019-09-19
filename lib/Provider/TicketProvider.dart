// Created By Jose Ignacio Lara Arandia 2019/09/17/time:03:49
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TicketProvider extends ChangeNotifier{
  String date = DateFormat("dd-MM-yyyy").format(DateTime.now());

  setDate(String dateTime){
    this.date =dateTime;
    notifyListeners();
  }
}

