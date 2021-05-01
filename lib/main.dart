import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewards_network_shared/const/theme.dart';
import 'package:rewardstender/Provider/CameraBloc.dart';
import 'package:rewardstender/Provider/TicketProvider.dart';
import 'package:rewardstender/services/firebase_service.dart';
import 'package:rewardstender/view/auth_view/auth_view.dart';
import 'package:rewardstender/view_model/auth_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("MyApp Called");
    final service = FirebaseAuthService(
        auth: FirebaseAuth.instance, database: FirebaseDatabase.instance);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
            create: (_) => AuthModel(authService: service)),
        ChangeNotifierProvider<CameraBloc>(create: (_) => CameraBloc()),
        ChangeNotifierProvider<TicketProvider>(create: (_) => TicketProvider()),
      ],
      child: MaterialApp(
        theme: lightTheme,
        title: 'ClerkAccount Tool',
        home: AuthView(),
      ),
    );
  }
}
