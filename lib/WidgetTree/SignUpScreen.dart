import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email, _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Sign Up"),),
      body: Column(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Email"
            ),
            onChanged: (input){
            _email=input;
            },
          ),


          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                hintText: "Password"
            ),
            onChanged: (input){
              _password=input;
            },
          ),

          RaisedButton(
            child: Text("SignUp"),
            onPressed: (){
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).whenComplete((){print("comppleted");});
            },
          )
        ],
      ),
    );
  }
}
