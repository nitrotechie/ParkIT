import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/login_screen.dart';
import 'package:parkit/services/helperfunctions.dart';

Future<User> googleSign() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

  var _authentication = await _googleSignInAccount!.authentication;
  var _credential = GoogleAuthProvider.credential(
    idToken: _authentication.idToken,
    accessToken: _authentication.accessToken,
  );

  User? user = (await _auth.signInWithCredential(_credential)).user;
  HelperFunctions.saveUserLoggedInSharedPreference(true);
  user!.updatePhotoURL(user.photoURL);
  return user;
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      Data.image = "";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    var ef = e;
  }
}

class Data {
  static var image;
  static var userName = "Anon";
  static var phno = "";
  static var balance = "0";
}
