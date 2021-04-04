import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:ignilab/controller/gender_select_controller.dart';
import 'package:ignilab/controller/invalid_login_controller.dart';
import 'package:ignilab/services/authentication_service.dart';
import 'package:ignilab/pages/auth/login.dart';
import 'package:ignilab/pages/splash.dart';
import 'package:ignilab/pages/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges),
          ChangeNotifierProvider<InvalidLoginController>.value(
              value: InvalidLoginController()),
          ChangeNotifierProvider<GenderSelectController>.value(
              value: GenderSelectController())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Auth',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return Welcome();
    }

    return Login();
  }
}
