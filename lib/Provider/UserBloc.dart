// // Created By Jose Ignacio Lara Arandia
//
// import 'package:flutter/material.dart';
// import 'package:rewards_network_shared/models/auth_fields.dart';
// import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
// import 'package:rewardstender/CloudServices/MyFireabaseAuth.dart';
// import 'package:rewardstender/Models/ClerkUser.dart';
// import 'package:rewardstender/Utils/Const.dart';
//
// class UserBloc extends ChangeNotifier {
//   ClerkAccount clerk;
//   Map user;
//   AuthStatus UserStatus;
//   String authError;
//   bool showAuthError=false;
//
//   signIn(String email, password)async{
//     String uid = await MyFirebaseAuth.signIn(email,password);
//     if(uid!=null){
//       user = await MyFirebase.getUser(uid);
//       if(user[UserFields.type]!=null){
//         if(user[UserFields.type]==UserFields.userTypeClerk){
//           UserStatus=UserStatus.signedIn; //Signed IN
//           clerk = await MyFirebase.getClerk(uid);
//           debugPrint("clerk = " + clerk.toString());
//           if(clerk?.userId ==null){
//             showAuthError=true;
//             authError="User data not found, contact developer for assistance";
//             signOut();
//           }
//         }else{
//           showAuthError=true;
//           authError=
//               "User is not a clerk, the user type is '"
//                   + user[UserFields.type] + "' "
//                   "Sign in to the correct app";
//
//           signOut();
//         }
//       }else{
//         showAuthError=true;
//         authError="Contact developer for help?";
//         signOut();
//       }
//     }
//     notifyListeners();
//   }
//
//   signOut() async{
//     await MyFirebaseAuth.signOut();
//     UserStatus =UserStatus.notSignedIn;
//     notifyListeners();
//   }
//
//   checkStatus()async{
//     debugPrint("checkStatusCalled");
//     String uid = await MyFirebaseAuth.currentlySignedIn();
//     if(uid!=null){
//       UserStatus=UserStatus.signedIn;
//       debugPrint("Getting ClerkAccount Data");
//       clerk =  await MyFirebase.getClerk(uid);
//     }else{
//       UserStatus=UserStatus.notSignedIn;
//     }
//   }
//
//   signUp(String email, String password)async{
//     clerk = await MyFirebase.createClerk(AuthFields(email: email, password: password), ClerkAccount());
//     notifyListeners();
//   }
// }
//
// enum AuthStatus{
//   signedIn,
//   notSignedIn,
//   Waiting,
// }
