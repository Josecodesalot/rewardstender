import 'package:firebase_database/firebase_database.dart';

class User {
  String email, userid, username, points;

  User(this.email, this.userid, this.username, this.points);

  void setUserFromSnapshot(DataSnapshot snap){
    User(
      snap.value["email"],
      snap.value("user_id"),
      snap.value["username"],
        snap.value["points"].toString()
    );
  }
}

class UserTools {

  static User getNewUserFromSnapShot(DataSnapshot snap) {
    if (snap.value != null) {
      Map map = new Map<String, dynamic>.from(snap.value);
      return new User(
          map["email"],
          map["user_id"],
          map["username"],
          map["points"].toString()
      );
    } else {
      print("null user from snap");
      return new User(
          "", "null user", "", ""
      );
    }
  }

  static Map getMapFromUser(User user){
    if(user==null){
      print("useris null");
    }

    Map<String, String> map;
    map["email"]= user.email;
    map["user_id"]= user.userid;
    map["username"]= user.username;
    map["poins"]= user.points;
    return map;
  }
}