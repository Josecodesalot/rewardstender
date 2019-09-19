// Created By Jose Ignacio Lara Arandia

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'FirebaseMethod.dart';

class MyFirebaseAuth{

  BuildContext context;
  static Future<String> currentlySignedIn()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user!=null){
      return user.uid.toString();
    }else{
      return null;
    }
  }

  static Future<String> signIn(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  static Future<Map> getUser(String uid)async{
    return await MyFirebase.getUser(uid);
  }

  static Future<void> signOut()async{
   FirebaseAuth.instance.signOut();
  }
}