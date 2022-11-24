import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/login_screen.dart';
import 'package:parkit/services/helperfunctions.dart';
import 'package:parkit/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> googleSign() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  var authentication = await googleSignInAccount!.authentication;
  var credential = GoogleAuthProvider.credential(
    idToken: authentication.idToken,
    accessToken: authentication.accessToken,
  );

  User? user = (await auth.signInWithCredential(credential)).user;
  HelperFunctions.saveUserLoggedInSharedPreference(true);
  prefs.setBool('login', true);
  user!.updatePhotoURL(user.photoURL);
  print(user);
  return user;
}

Future<bool> logOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    await auth.signOut().then((value) {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      Data.image = "";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
    prefs.setBool('login', false);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> isPhoneRegistered(String phone) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('phone', isEqualTo: phone)
      .limit(1)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<bool> registerUser() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('users').doc(Data.phno).set({
      "name": Data.userName,
      "email": Data.userEmail,
      "phone": Data.phno,
    });
    return true;
  } catch (e) {
    return false;
  }
}



class Data {
  static var userEmail = "";
  static var phno = "";
  static var balance = "0";
  static var hatchback = "assets/images/hatchback.png";
  static var coupe = "assets/images/coupe.png";
  static var pickup = "assets/images/pickup.png";
  static var sedan = "assets/images/sedan.png";
  static var suv = "assets/images/suv.png";
  static String userName = "Anon";
  static getUsername() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName = user.displayName.toString();
    }
  }

  static String image = "";
  static getImage() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      image = user.photoURL.toString();
    }
  }

  static double lat = 0.0;
  static double lon = 0.0;

  static Future getCurrentPosition(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission asked = await Geolocator.requestPermission();
      if (asked == LocationPermission.denied ||
          asked == LocationPermission.deniedForever) {
        final snackBar =
            Widgets.showSnackBar("Permission for location is denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // ignore: use_build_context_synchronously
        getCurrentPosition(context);
      }
    } else {
      Position currentPostion = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      lat = currentPostion.latitude;
      lon = currentPostion.longitude;
    }
  }
}
