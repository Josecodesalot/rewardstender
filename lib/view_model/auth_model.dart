import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rewards_network_shared/models/auth_fields.dart';
import 'package:rewards_network_shared/models/clerk.dart';
import 'package:rewards_network_shared/models/client_state.dart';
import 'package:rewards_network_shared/models/user_status.dart';
import 'package:rewards_network_shared/services/auth_service.dart';

class AuthModel extends ChangeNotifier {
  AuthModel({@required this.authService});

  final AuthService authService;
  StackTrace stackTrace;
  UserState _clientState;

  UserState<ClerkAccount> get clientState => _clientState;

  set clientState(UserState guest) {
    _clientState = guest;
    notifyListeners();
  }

  void userEnteredApp() async {
    //check if user is signed in
    final authCheckResponse = await authService.checkAuthStatus();

    if (authCheckResponse.hasError) {
      clientState = UserState(status: UserStatus.signedOut);
    }
    clientState = authCheckResponse.data;

    // un comment for test purposes
    // if(kDebugMode) {
    //   //if user is not logged in, sign in anon
    //   if (clientState.status == UserStatus.signedOut) {
    //     signInAnon();
    //   }
    // }
  }

  void signOut() async {
    final authResponse = await authService.signOut();
    if (authResponse.hasError) {
      //handle
    }
    clientState = authResponse.data;
  }

  void signIn(AuthFields authFields, {@required Function onError}) async {
    print('signIn()');
    final signInResult = await authService.signIn(authFields);
    clientState = signInResult.data;
    if (signInResult.hasError) {
      onError(signInResult.error);
    }
  }

  void signInAnon() async {
    print('signInAnon()');
    final result = await authService.signInAnon();
    if (result.hasError) {

    }
    clientState = result.data;
  }

  Future<void> signUp(
    final AuthFields authFields, {
    final Function onError,
  }) async {
    print('signUp()');
    final result = await authService.signUp(authFields);
    if (result.hasError) {
      onError(result.error);
    } else {
      this.clientState = result.data;
    }
  }
}
