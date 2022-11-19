import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:parkit/screens/home_screen.dart';
import 'package:parkit/screens/login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Data d = Data();
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 4), () {
    //   checkFirstSeen();
    // });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/logo.gif',
          ),
          Image.asset(
            'assets/images/sp.png',
          ),
        ],
      ),
    ));
  }
}
