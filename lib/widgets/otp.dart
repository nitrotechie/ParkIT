// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/screens/bottom_navigation_bar.dart';
import 'package:parkit/services/helperfunctions.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKeyOTP = GlobalKey<FormState>();
  var changeButton = false;
  var active = false;
  var time;
  String? verificationCode;
  final TextEditingController otp = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void activateButton() {
    time = Timer(const Duration(seconds: 30), (() {
      active = true;
      setState(() {});
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginPhone(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    time.cancel();
  }

  Future loginPhone(BuildContext context) async {
    changeButton = true;
    setState(() {});
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+91${Data.phno}",
        verificationCompleted: ((credential) async {
          otp.text = credential.smsCode.toString();
          changeButton = true;
          setState(() {});
          SharedPreferences prefs = await SharedPreferences.getInstance();
          User? user = (await auth.signInWithCredential(credential)).user;
          if (user != null) {
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where('phone', isEqualTo: Data.phno)
                .limit(1)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            Map<String, dynamic> data =
                documents.first.data() as Map<String, dynamic>;
            await user.updateDisplayName(data['name']);
            await user.updatePhotoURL(data['userImage']);
            await firestore.collection('users').doc(Data.phno).set({
              "uid": auth.currentUser!.uid,
            }, SetOptions(merge: true));

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            prefs.setBool('login', true);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen()),
                (Route<dynamic> route) => false);
            changeButton = false;
          }
        }),
        verificationFailed: ((error) {}),
        codeSent: ((verificationId, forceResendingToken) async {
          activateButton();
          changeButton = false;
          setState(() {
            verificationCode = verificationId;
          });
        }),
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30),
      );
    } catch (e) {
      final snackBar = Widgets.showSnackBar(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.indigo.withOpacity(0.1),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Verification",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "In less than a minute",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LottieBuilder.asset(
                            "assets/animation/otp.json",
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Form(
                            key: _formKeyOTP,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "We've sent an OTP on mobile number +91${Data.phno}",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "OTP",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Pinput(
                                  controller: otp,
                                  length: 6,
                                  showCursor: true,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    decoration: BoxDecoration(
                                      color: MyTheme.ligthBluishColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      child: const Text(
                                        "GET STARTED",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (otp.length == 6) {
                                          changeButton = true;
                                          setState(() {});
                                          try {
                                            AuthCredential credential =
                                                PhoneAuthProvider.credential(
                                                    verificationId:
                                                        verificationCode!,
                                                    smsCode: otp.text);
                                            User? user = (await auth
                                                    .signInWithCredential(
                                                        credential))
                                                .user;
                                            if (user != null) {
                                              final QuerySnapshot result =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('phone',
                                                          isEqualTo: Data.phno)
                                                      .limit(1)
                                                      .get();
                                              final List<DocumentSnapshot>
                                                  documents = result.docs;
                                              Map<String, dynamic> data =
                                                  documents.first.data()
                                                      as Map<String, dynamic>;
                                              await user.updateDisplayName(
                                                  data['name']);
                                              await user.updatePhotoURL(
                                                  data['userImage']);
                                              await firestore
                                                  .collection('users')
                                                  .doc(Data.phno)
                                                  .set({
                                                "uid": auth.currentUser!.uid,
                                              }, SetOptions(merge: true));

                                              HelperFunctions
                                                  .saveUserLoggedInSharedPreference(
                                                      true);
                                              prefs.setBool('login', true);
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const BottomNavigationBarScreen()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                              changeButton = false;
                                            }
                                          } catch (e) {
                                            changeButton = false;
                                            setState(() {});
                                            if (e.toString().contains(
                                                "invalid-verification-code")) {
                                              final snackBar =
                                                  Widgets.showSnackBar(
                                                      "Invalid Verification Code");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        } else {
                                          final snackBar = Widgets.showSnackBar(
                                              "Please Enter OTP");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: active == true
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const OTPScreen()));
                                          },
                                          child: const Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          "Wait for an OTP",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        changeButton == true
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Center(
                  child: LottieBuilder.asset(
                    "assets/animation/car-loader.json",
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
