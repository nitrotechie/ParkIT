import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> logInEmail() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: "s.ankit1140@gmail.com", password: "Shreesai@359"))
        .user;

    if (user != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

class Private {
  static String mid = "XDIgMk57692523100005";
}
