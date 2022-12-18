// ignore_for_file: avoid_function_literals_in_foreach_calls

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
import 'package:intl/intl.dart';
import 'package:parkit/screens/add_money.dart';
import 'package:parkit/screens/login_screen.dart';
import 'package:parkit/screens/payment_screen.dart';
import 'package:parkit/services/helperfunctions.dart';
import 'package:parkit/services/private_services.dart';
import 'package:parkit/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
    await firestore
        .collection('users')
        .doc(Data.phno)
        .collection('bookings')
        .doc('A')
        .set({'bookingId': 'null'});
    await firestore
        .collection('users')
        .doc(Data.phno)
        .collection('vehicles')
        .doc('A')
        .set({'registration_number': 'null'});
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
    return true;
  } else {
    return false;
  }
}

getFuelPrice() async {
  String date = DateFormat.MMMEd().format(DateTime.now());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var url =
      'https://daily-petrol-diesel-lpg-cng-fuel-prices-in-india.p.rapidapi.com/v1/fuel-prices/today/india/states';
  var headers = {
    'X-RapidAPI-Host':
        'daily-petrol-diesel-lpg-cng-fuel-prices-in-india.p.rapidapi.com',
    'X-RapidAPI-Key': Private.fuelApiKey,
    'Content-Type': 'application/json'
  };
  final result =
      await firestore.collection('maintainance').doc('dateMaintain').get();
  final value = result.data();
  final dateFromdata = value!['date'];

  if (date != dateFromdata) {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await uploadFuelData(data);
      return true;
    } else {
      return false;
    }
  }
}

uploadFuelData(data) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String date = DateFormat.MMMEd().format(DateTime.now());
  List list = data['statePrices'];
  var len = list.length;
  for (var i = 0; i < len; i++) {
    var fdata = {
      'petrolPrice': data['statePrices'][i]['fuel']['petrol']['retailPrice'],
      'petrolPriceChange': data['statePrices'][i]['fuel']['petrol']
          ['retailPriceChange'],
      'dieselPrice': data['statePrices'][i]['fuel']['diesel']['retailPrice'],
      'dieselPriceChange': data['statePrices'][i]['fuel']['diesel']
          ['retailPriceChange'],
    };
    await firestore
        .collection('fuelPrice')
        .doc(data['statePrices'][i]['stateName'])
        .set(fdata);
  }
  await firestore.collection('maintainance').doc('dateMaintain').set({
    'date': date,
  });
}

Future<bool> bookParkingSpot(
  bookingId,
  bookingDate,
  bookingTime,
  vehicleType,
  name,
  projectId,
  vehicleName,
  rcNo,
  timeIn,
  timeOut,
  dateIn,
  dateOut,
  availableSpaceBike,
  availableSpaceCar,
  amount,
  diffrence,
  dateTimeIn,
  dateTimeOut,
  address,
  imageUrl,
) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot result = await firestore
      .collection('parking-space')
      .doc(projectId)
      .collection('bookings')
      .where('bookingId', isEqualTo: "null")
      .where('type', isEqualTo: vehicleType)
      .limit(1)
      .get();
  List<DocumentSnapshot> dataa = result.docs;
  Map<String, dynamic> daaata = dataa[0].data() as Map<String, dynamic>;
  var spot = daaata['spot'];
  Map<String, dynamic> data = {
    'userPhone': user!.phoneNumber.toString().replaceAll('+91', ''),
    'rcNo': rcNo,
    'bookingId': bookingId,
    'bookingDate': bookingDate,
    'bookingTime': bookingTime,
    'vehicleType': vehicleType,
    'parkingName': name,
    'projectId': projectId,
    'vehicleName': vehicleName,
    'timeIn': timeIn,
    'timeOut': timeOut,
    'dateIn': dateIn,
    'dateOut': dateOut,
    'bookingStatus': 'Active',
    'bookingAmount': amount,
    'bookedHours': diffrence,
    'dateTimeIn': dateTimeIn.toString(),
    'dateTimeOut': dateTimeOut.toString(),
    'address': address,
    'spot': spot,
    'imageUrl': imageUrl,
  };
  try {
    firestore.collection('all-bookings').doc(bookingId).set(data);
    firestore
        .collection('users')
        .doc(user.phoneNumber.toString().replaceAll('+91', ''))
        .collection('bookings')
        .doc(bookingId)
        .set(data);

    firestore
        .collection('parking-space')
        .doc(projectId)
        .collection('bookings')
        .doc(spot)
        .set(
          data,
          SetOptions(
            merge: true,
          ),
        );
    vehicleType == "Bike"
        ? firestore.collection('parking-space').doc(projectId).update({
            'availableSpaceBike':
                (int.parse(availableSpaceBike) - 1).toString(),
          })
        : firestore.collection('parking-space').doc(projectId).update({
            'availableSpaceCar': (int.parse(availableSpaceCar) - 1).toString(),
          });
    await firestore
        .collection('users')
        .doc(user.phoneNumber.toString().replaceAll('+91', ''))
        .collection('bookings')
        .doc('A')
        .delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> checkPreviousParking(
  rcNo,
  dateIn,
  DateTime dateTimeIn,
  DateTime dateTimeOut,
) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot data = await firestore
      .collection('all-bookings')
      .where('rcNo', isEqualTo: rcNo)
      .where('bookingStatus', isEqualTo: 'Active')
      .where('dateIn', isEqualTo: dateIn)
      .get();
  List ta = [];
  if (data.docs.isEmpty) {
    return true;
  }
  data.docs.forEach((element) {
    ta.add(element.data());
  });
  if (ta.isEmpty) {
    return true;
  } else {
    for (var x in ta) {
      DateTime dt1 = DateTime.parse(x['dateTimeIn']);
      DateTime dt2 = DateTime.parse(x['dateTimeOut']);

      return !(dateTimeIn.isAfter(dt1) && dateTimeIn.isBefore(dt2));
    }
    return true;
  }
}

Future<bool> checkTiming(Stream<QuerySnapshot<Object?>> result,
    DateTime dateTimeIn, DateTime dateTimeOut) {
  return result.every((element) {
    var data = element.docs;
    return data.every((e) {
      QueryDocumentSnapshot x = e;
      DateTime dt1 = DateTime.parse(x['dateTimeIn']);
      DateTime dt2 = DateTime.parse(x['dateTimeOut']);
      print((dateTimeIn.isAfter(dt1) && dateTimeIn.isBefore(dt2)));
      return (dateTimeIn.isAfter(dt1) && dateTimeIn.isBefore(dt2));
    });
  });
}

Future<bool> getVehicleDetails(String rcNo) async {
  Uuid uuid = Uuid();
  var url =
      'https://rc-verification.p.rapidapi.com/v3/tasks/sync/verify_with_source/ind_rc_plus';
  var headers = {
    'X-RapidAPI-Host': 'rc-verification.p.rapidapi.com',
    'X-RapidAPI-Key': Private.rcVerificationApiKey,
    'Content-Type': 'application/json'
  };
  var body = {
    'task_id': uuid.v4(),
    'group_id': uuid.v4(),
    'data': {
      'rc_number': rcNo,
    }
  };

  String b = jsonEncode(body);
  final http.Response response = await http.post(
    Uri.parse(url),
    body: b,
    headers: headers,
  );
  final data = jsonDecode(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    await uploadVehicleData(data);
    return true;
  } else {
    return false;
  }
}

uploadVehicleData(data) async {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    print(data['result']['extraction_output']['registration_number']);
    await firestore
        .collection('users')
        .doc(user!.phoneNumber.toString().replaceAll('+91', ''))
        .collection('vehicles')
        .doc(data['result']['extraction_output']['registration_number'])
        .set({
      'noc_valid_upto': data['result']['extraction_output']['noc_valid_upto'],
      'registration_number': data['result']['extraction_output']
          ['registration_number'],
      'seating_capacity': data['result']['extraction_output']
          ['seating_capacity'],
      'fitness_upto': data['result']['extraction_output']['fitness_upto'],
      'variant': data['result']['extraction_output']['variant'],
      'npermit_upto': data['result']['extraction_output']['npermit_upto'],
      'manufacturer_model': data['result']['extraction_output']
          ['manufacturer_model'],
      'standing_capacity': data['result']['extraction_output']
          ['standing_capacity'],
      'status': data['result']['extraction_output']['status'],
      'status_message': data['result']['extraction_output']['status_message'],
      'number_of_cylinder': data['result']['extraction_output']
          ['number_of_cylinder'],
      'colour': data['result']['extraction_output']['colour'],
      'puc_valid_upto': data['result']['extraction_output']['puc_valid_upto'],
      'vehicle_class': data['result']['extraction_output']['vehicle_class'],
      'permanent_address': data['result']['extraction_output']
          ['permanent_address'],
      'permit_no': data['result']['extraction_output']['permit_no'],
      'father_name': data['result']['extraction_output']['father_name'],
      'status_verfy_date': data['result']['extraction_output']
          ['status_verfy_date'],
      'm_y_manufacturing': data['result']['extraction_output']
          ['m_y_manufacturing'],
      'registration_date': data['result']['extraction_output']
          ['registration_date'],
      'gross_vehicle_weight': data['result']['extraction_output']
          ['gross_vehicle_weight'],
      'registered_place': data['result']['extraction_output']
          ['registered_place'],
      'permit_validity_upto': data['result']['extraction_output']
          ['permit_validity_upto'],
      'insurance_policy_no': data['result']['extraction_output']
          ['insurance_policy_no'],
      'noc_details': data['result']['extraction_output']['noc_details'],
      'npermit_issued_by': data['result']['extraction_output']
          ['npermit_issued_by'],
      'sleeper_capacity': data['result']['extraction_output']
          ['sleeper_capacity'],
      'current_address': data['result']['extraction_output']['current_address'],
      'status_verificationpermit_type': data['result']['extraction_output']
          ['status_verificationpermit_type'],
      'permit_type': data['result']['extraction_output']['permit_type'],
      'noc_status': data['result']['extraction_output']['noc_status'],
      'masked_name': data['result']['extraction_output']['masked_name'],
      'fuel_type': data['result']['extraction_output']['fuel_type'],
      'permit_validity_from': data['result']['extraction_output']
          ['permit_validity_from'],
      'owner_name': data['result']['extraction_output']['owner_name'],
      'puc_number': data['result']['extraction_output']['puc_number'],
      'owner_mobile_no': data['result']['extraction_output']['owner_mobile_no'],
      'blacklist_statusmanufacturer': data['result']['extraction_output']
          ['blacklist_statusmanufacturer'],
      'manufacturer': data['result']['extraction_output']['manufacturer'],
      'permit_issue_date': data['result']['extraction_output']
          ['permit_issue_date'],
      'engine_numberchassis_number': data['result']['extraction_output']
          ['engine_numberchassis_number'],
      'chassis_number': data['result']['extraction_output']['chassis_number'],
      'mv_tax_upto:': data['result']['extraction_output']['mv_tax_upto:'],
      'body_type': data['result']['extraction_output']['body_type'],
      'unladden_weight': data['result']['extraction_output']['unladden_weight'],
      'insurance_name': data['result']['extraction_output']['insurance_name'],
      'owner_serial_number': data['result']['extraction_output']
          ['owner_serial_number'],
      'vehicle_category': data['result']['extraction_output']
          ['vehicle_category'],
      'noc_issue_date': data['result']['extraction_output']['noc_issue_date'],
      'npermit_no': data['result']['extraction_output']['npermit_no'],
      'cubic_capacity': data['result']['extraction_output']['cubic_capacity'],
      'norms_type': data['result']['extraction_output']['norms_type'],
      'state': data['result']['extraction_output']['state'],
      'insurance_validity': data['result']['extraction_output']
          ['insurance_validity'],
      'financer': data['result']['extraction_output']['financer'],
      'wheelbase': data['result']['extraction_output']['wheelbase'],
      'vehicle_type':
          data['result']['extraction_output']['vehicle_category'] == "2WN"
              ? 'Bike'
              : 'Car',
    });
    await firestore
        .collection('users')
        .doc(user.phoneNumber.toString().replaceAll('+91', ''))
        .collection('vehicles')
        .doc('A')
        .delete();
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
