import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/Provider/UserBloc.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String _email;
  String _password;
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of<UserBloc>(context);
    debugPrint("LoginPageCalled");

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: mForm(),
    );
  }

  Widget mForm(){

    Widget hey;
    if (userBloc.showAuthError){
      hey = Text(userBloc.authError);
    }
    if(hey==null){
      hey = Container();
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            TextFormField(
              key: Key('email'),
              decoration: InputDecoration(labelText: 'Email'),
              validator: EmailFieldValidator.validate,
              onSaved: (String value) => _email = value,
            ),
            TextFormField(
              key: Key('password'),
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: PasswordFieldValidator.validate,
              onSaved: (String value) => _password = value,
            ),
            RaisedButton(
              key: Key('signIn'),
              child: Text('Login', style: TextStyle(fontSize: 20.0)),
              onPressed: ()async {
                if(validateAndSave()){
                  await userBloc.signIn(_email, _password);
                }
              },
            ),
            Center(child: hey),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final FormState form = loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}