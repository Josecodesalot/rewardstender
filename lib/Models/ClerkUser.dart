// import 'package:firebase_database/firebase_database.dart';
// import 'package:rewardstender/Utils/Const.dart';
//
// class ClerkAccount {
//   String name, userId, email, placeName, placeId, timeCreated;
//
//   ClerkAccount(
//       {this.email,
//       this.userId,
//       this.name,
//       this.placeName,
//       this.placeId,
//       this.timeCreated});
//
//   factory ClerkAccount.fromMap(Map<String, dynamic> map) {
//     return ClerkAccount(
//       name: map['name'],
//       userId: map['user_id'],
//       email: map['email'],
//       placeName: map['placeName'],
//       placeId: map['placeId'],
//       timeCreated: map['dateCreated'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     // ignore: unnecessary_cast
//     return {
//       'name': this.name,
//       'user_id': this.userId,
//       'email': this.email,
//       'placeName': this.placeName,
//       'placeId': this.placeId,
//       'dateCreated': this.timeCreated,
//     } as Map<String, dynamic>;
//   }
//
//   ClerkAccount copyWith({
//     String name,
//     String userId,
//     String email,
//     String placeName,
//     String placeId,
//     String timeCreated,
//   }) {
//     return ClerkAccount(
//       name: name ?? this.name,
//       userId: userId ?? this.userId,
//       email: email ?? this.email,
//       placeName: placeName ?? this.placeName,
//       placeId: placeId ?? this.placeId,
//       timeCreated: timeCreated ?? this.timeCreated,
//     );
//   }
// }
//
// class ClerkTools {
//   static ClerkAccount getNewUserFromSnapShot(DataSnapshot snap) {
//     if (snap.value != null) {
//       Map map = new Map<String, dynamic>.from(snap.value);
//       return new ClerkAccount(
//           email: map[Const.email],
//           userId: map[Const.userId],
//           name: map[Const.username],
//           placeName: map[Const.placeName],
//           placeId: map[Const.placeId],
//           timeCreated: map[Const.dateCreated]);
//     } else {
//       print("null user from snap");
//       return ClerkAccount();
//     }
//   }
//
//   static Map getMapFromUser(ClerkAccount user) {
//     if (user == null) {
//       print("useris null");
//     }
//     Map<String, String> map;
//     map[Const.email] = user.email;
//     map[Const.userId] = user.userId;
//     map[Const.username] = user.name;
//     return map;
//   }
//
// }
