import 'package:firebase_database/firebase_database.dart';
import 'package:rewardstender/Utils/Const.dart';

class MyRefs{
  static DatabaseReference db = FirebaseDatabase.instance.reference();

  static DatabaseReference getHistoryList(String placeId, String clerkId){
    return db.child(placeId).child(clerkId);
  }

  static DatabaseReference getUser(String uid){
    return db.child(MainFields.users).child(uid);
  }

  static getClerk(String uid) {
    return db.child(MainFields.clerks).child(uid);
  }
}