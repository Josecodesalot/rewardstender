import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewardstender/services/firebase_place_service.dart';
import 'package:rewardstender/view_model/authenticate_model.dart';

class AuthenticateModelInjector extends StatelessWidget {
  final Widget child;
  AuthenticateModelInjector({@required this.child});

  @override
  Widget build(BuildContext context) {
    final playService = FirebasePlaceService(FirebaseDatabase.instance);
    return ChangeNotifierProvider(
      create: (_)=> AuthenticateModel(placeService: playService),
      child: child,
    );
  }
}
