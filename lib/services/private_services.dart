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
  static String rcVerificationApiKey =
      "783c8e21b2msh39ac9dc22b315b4p1a5b81jsnc2fd4650956a";
}

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
