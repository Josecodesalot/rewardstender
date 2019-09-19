// Created By Jose Ignacio Lara Arandia 2019/09/11/time:09:35

import 'package:flutter/material.dart';

class CameraBloc extends ChangeNotifier{
  bool resultGotten = false;
  String result = "ready to scan!";
  ButtonActivator buttonActivator;
  bool newCostumer =false;

  changeResultStatus(bool b){
    resultGotten= b;
    notifyListeners();
  }

  setResult(String newResult){
    result = newResult;
    notifyListeners();
  }

  triggerButton(ButtonActivator activator){
    buttonActivator =activator;
    notifyListeners();
  }

  void setResulGottem(bool b) {
    resultGotten=b;
    notifyListeners();
  }
}

enum ButtonActivator{
  noPoints,
  fiveDollars,
  tenDollars,
  twentyDollars
}