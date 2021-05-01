import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewards_network_shared/models/client_state.dart';
import 'package:rewards_network_shared/models/user_status.dart';
import 'package:rewardstender/view/confirm_email_view/confirm_email_view.dart';
import 'package:rewardstender/view/authenticate_view/authenticate_view.dart';
import 'package:rewardstender/view/home_view/home_view.dart';
import 'package:rewardstender/view_model/auth_model.dart';

class AuthView extends StatefulWidget {
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  void initState() {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    authModel.userEnteredApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthModel, UserState>(
      selector: (_, authModel) => authModel.clientState,
      builder: (_, clientState, child) {
        print('AuthBuilder built with ${clientState?.status}');
        switch (clientState?.status ?? UserStatus.toBeDetermined) {
          case UserStatus.anon:
          case UserStatus.signedIn:
          case UserStatus.signedInWeak:
            if(kDebugMode){
              return HomeView();
            }
            return ConfirmEmailView();
          case UserStatus.signedOut:
            return AuthenticateView();
          case UserStatus.toBeDetermined:
            return const SizedBox();
          default:
            assert(false,
                'un-accounted for state inside of Selector<AuthModel, UserStatus>');
            return const SizedBox();
        }
      },
    );
  }
}
