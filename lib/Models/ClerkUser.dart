import 'package:firebase_database/firebase_database.dart';
import 'package:rewardstender/Utils/Const.dart';

class Clerk  {
  String name, user_id, email, placeName, placeId;
  Clerk(this.email, this.user_id,  this.name, this.placeName, this.placeId);

}

class ClerkTools {

  static Clerk getNewUserFromSnapShot(DataSnapshot snap) {
    if (snap.value != null) {
      Map map = new Map<String, dynamic>.from(snap.value);
      return new Clerk(
          map[Const.email],
          map[Const.userId],
          map[Const.username],
          map[Const.placeName],
          map[Const.placeId]

      );
    } else {
      print("null user from snap");
      return new Clerk(
          "", "null user", "","",""
      );
    }
  }

  static Map getMapFromUser(Clerk user){
    if(user==null){
      print("useris null");
    }

    Map<String, String> map;
    map[Const.email]= user.email;
    map[Const.userId]= user.user_id;
    map[Const.username]= user.name;
    return map;
  }

  static  Clerk developerCleck(){
    return Clerk("clerk@clerk.com","userKey","jose the clerk","Jose's Place","-Li9xb3s2SVMKJgt-n0s");
  }
}