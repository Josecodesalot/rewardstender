import 'package:firebase_database/firebase_database.dart';
import 'package:rewardstender/Utils/Const.dart';

class Costumer {
  String email, userid, username, points;

  Costumer(this.email, this.userid, this.username, this.points);

  void setCostumerFromSnapShot(DataSnapshot snap){
    Costumer(
        snap.value[Const.email],
        snap.value(Const.userId),
        snap.value[Const.username],
        snap.value[Const.points].toString()
    );
  }
}

class CostumerTools {

  static Costumer getCostumerFromSnapshot(DataSnapshot snap) {
    if (snap.value != null) {
      Map map = new Map<String, dynamic>.from(snap.value);
      return  Costumer(
          map[Const.email],
          map[Const.userId],
          map[Const.username],
          map[Const.points].toString()
      );
    } else {
      print("null user from snap");
      return Costumer(
          "", "null user", "", ""
      );
    }
  }

  static Map getCostumerMapFromModel(Costumer costumer){
    if(costumer==null){
      print("useris null");
    }
    Map<String, String> map;
    map[Const.email]= costumer.email;
    map[Const.userId]= costumer.userid;
    map[Const.username]= costumer.username;
    map[Const.points]= costumer.points;
    return map;
  }
}