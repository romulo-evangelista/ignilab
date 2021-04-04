import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ignilab/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => AuthenticationWrapper(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF43B1BF),
            Color(0xFF533A71),
          ],
        ),
      ),
      child: Center(
        child: Image.asset('assets/Logo.png'),
      ),
    );
  }
}
