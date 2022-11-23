import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/screens/bottom_navigation_bar.dart';
import 'package:parkit/screens/login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Data d = Data();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      checkLogin();
    });
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');

    if (login == true) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen()));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
          LottieBuilder.asset("assets/animation/park.json"),
        ],
      ),
    ));
  }
}
