import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/add_money.dart';
import 'package:parkit/screens/login_screen.dart';
import 'package:parkit/screens/payment_screen.dart';
import 'package:parkit/services/helperfunctions.dart';
import 'package:parkit/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// genrateToken() async {
//   var uuid = const Uuid();
//   var url =
//       "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyBoC1TEBUD6iMq_YBEDig8dkkFvUX6hgBw";

//   var headers = {'Content-Type': 'application/json'};

//   final body = {"token": uuid.v1(), "returnSecureToken": true};

//   final http.Response response = await http.post(
//     Uri.parse(url),
//     body: jsonEncode(body),
//     headers: headers,
//   );
//   if (response.statusCode == 201) {
//     print(response.body);
//   } else if (response.statusCode == 400) {
//     print(response.body);
//   }
// }

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

Future<bool> addNewVehicle(rcNo) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final QuerySnapshot result = await firestore
      .collection('users')
      .doc(user!.phoneNumber.toString().replaceAll('+91', ''))
      .collection('vehicles')
      .where('rcNo', isEqualTo: rcNo)
      .limit(1)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.isNotEmpty) {
    await getVehicleDetails(rcNo);
    return true;
  } else {
    return false;
  }
}

getVehicleDetails(String rcNo) async {
  Uuid uuid = Uuid();
  var url =
      'https://rc-verification.p.rapidapi.com/v3/tasks/sync/verify_with_source/ind_rc_plus';
  var headers = {
    'X-RapidAPI-Host' : 'rc-verification.p.rapidapi.com',
    'X-RapidAPI-Key' : '783c8e21b2msh39ac9dc22b315b4p1a5b81jsnc2fd4650956a',
    'Content-Type': 'application/json'
  };
  var body = {
    'task_id': uuid.v4(),
    'group_id': uuid.v4(),
    'data': {'rc_number': rcNo,}
  };

  String b = jsonEncode(body);
  final http.Response response = await http.post(
    Uri.parse(url),
    body: b,
    headers: headers,
  );
  print(response.body);
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
  static bool isLoading = true;

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

  static double calculateDistance(lat, long) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat - Data.lat) * p) / 2 +
        cos(Data.lat * p) * cos(lat * p) * (1 - cos((long - Data.lon) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static buildDynamicLinks(String orderId) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://nitrotechie.page.link"),
      uriPrefix: "https://nitrotechie.page.link/id",
      androidParameters: const AndroidParameters(
        packageName: "com.nitrotechie.parkit",
        minimumVersion: 0,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    print(dynamicLink);
  }
}
