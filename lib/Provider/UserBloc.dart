// Created By Jose Ignacio Lara Arandia

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rewardstender/CloudServices/FirebaseMethod.dart';
import 'package:rewardstender/CloudServices/MyFireabaseAuth.dart';
import 'package:rewardstender/Utils/Const.dart';

class UserBloc extends ChangeNotifier {
  String userId="null";
  Map clerk;
  Map user;
  AuthStatus authStatus;
  String authError;
  bool showAuthError=false;

  signIn(String email, password)async{
    String uid = await MyFirebaseAuth.signIn(email,password);
    if(uid!=null){
      user = await MyFirebase.getUser(uid);
      if(user[UserFields.type]!=null){
        if(user[UserFields.type]==UserFields.userTypeClerk){
          userId=uid;
          authStatus=AuthStatus.signedIn; //Signed IN
          clerk = await MyFirebase.getClerk(uid);
          debugPrint("clerk = " + clerk.toString());
          if(clerk.isEmpty){
            showAuthError=true;
            authError="User data not found, contact developer for assistance";
            signOut();
          }
        }else{
          showAuthError=true;
          authError=
              "User is not a clerk, the user type is '"
                  + user[UserFields.type] + "' "
                  "Sign in to the correct app";

          signOut();
        }
      }else{
        showAuthError=true;
        authError="Contact developer for help?";
        signOut();
      }
    }
    debugPrint("user id = " + userId);
    notifyListeners();
  }

  signOut() async{
    await MyFirebaseAuth.signOut();
    authStatus =AuthStatus.notSignedIn;
    notifyListeners();
  }

  checkStatus()async{
    debugPrint("checkStatusCalled");
    String uid = await MyFirebaseAuth.currentlySignedIn();
    if(uid!=null){
      debugPrint("signedIn");
      authStatus=AuthStatus.signedIn;
      debugPrint("Getting Clerk Data");
      clerk =  await MyFirebase.getClerk(uid);
    }else{
      debugPrint("noSignedIn");
      authStatus=AuthStatus.notSignedIn;
    }
  }
}

enum AuthStatus{
  signedIn,
  notSignedIn,
  Waiting,
}
