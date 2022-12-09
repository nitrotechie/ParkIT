import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lo;
import 'package:intl/intl.dart';
import 'package:parkit/screens/booking_details.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class ParkingSpotScreen extends StatefulWidget {
  final String projectId;
  final String distance;
  final String type;
  const ParkingSpotScreen(
      {super.key,
      required this.projectId,
      required this.distance,
      required this.type});

  @override
  State<ParkingSpotScreen> createState() => _ParkingSpotScreenState();
}

class _ParkingSpotScreenState extends State<ParkingSpotScreen> {
  TextEditingController rcNu = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  var lat = 0.0;
  var long = 0.0;
  String name = "";
  String availableSpaceBike = "";
  String availableSpaceCar = "";
  String imageUrl = "";
  String logoUrl = "";
  String priceBike = "";
  String priceCar = "";
  String projectId = "";
  String areaName = "";
  String bikeTime = "";
  String carTime = "";
  String timeIn = "";
  String timeOut = "";
  String dateIn = "";
  String dateOut = "";
  String address = "";
  int diffrence = 1;
  DateTime dateTimeIn = DateTime.now();
  DateTime dateTimeOut = DateTime.now();
  DateTime dateTime = DateTime.now();
  bool vehicleSelected = false;
  String vehicleName = '';
  String vehicleType = '';
  String rcNo = '';
  String amount = "0";
  bool changeButton = false;
  Timer? timer;
  String time = '0';
  String price = '0';

  @override
  void initState() {
    super.initState();
    buildDateTimeIn(dateTime);
    buildDateTimeOut(dateTime);
    findDiffrenceTime();
    timer = Timer.periodic(const Duration(minutes: 15), (Timer t) => getTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getTime() {
    dateTimeIn = DateTime.now();
    dateTimeOut = DateTime.now();
    dateTime = DateTime.now();
  }

  calculateAmount(time, price) {
    if (time != '0' && price != '0') {
      double a = diffrence / int.parse(time);
      int b = diffrence ~/ int.parse(time);
      int c = b.toDouble() < a ? b + 1 : b;
      diffrence <= int.parse(time)
          ? amount = price
          : amount = (c * int.parse(price)).toString();
    } else {
      amount = '0';
    }
  }

  // getParkingDetails(String projectId) {
  //   final docRef = firebase.collection("parking-space").doc(projectId);
  //   docRef.snapshots().listen(
  //     (event) {
  //       Map<String, dynamic> x = event.data() as Map<String, dynamic>;
  // name = x['name'];
  // availableSpaceBike = x['availableSpaceBike'];
  // availableSpaceCar = x['availableSpaceCar'];
  // imageUrl = x['imageUrl'];
  // logoUrl = x['logoUrl'];
  // lat = double.parse(x['lat']);
  // long = double.parse(x['long']);
  // priceBike = x['priceBike'];
  // priceCar = x['priceCar'];
  // projectId = x['projectId'];
  // areaName = x['areaName'];
  // bikeTime = x['bikeTime'];
  // carTime = x['carTime'];
  //       setState(() {});
  //     },
  //     onError: (e) {},
  //   );
  // }

  DateTime nearestHalfTimeIn(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour,
        [0, 30, 60][(val.minute / 30).round()]);
  }

  DateTime nearestHalfTimeOut(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour + 1,
        [0, 30, 60][(val.minute / 30).round()]);
  }

  buildDateTimeIn(DateTime dateTime) {
    dateTimeIn = nearestHalfTimeIn(dateTime);
    print(dateTimeIn);
    timeIn = DateFormat.jm().format(nearestHalfTimeIn(dateTime)).toString();
    dateIn = DateFormat.MMMEd().format(nearestHalfTimeIn(dateTime));
    setState(() {});
  }

  buildDateTimeOut(DateTime dateTime) {
    dateTimeOut = nearestHalfTimeOut(dateTime);
    timeOut = DateFormat.jm().format(nearestHalfTimeOut(dateTime)).toString();
    dateOut = DateFormat.MMMEd().format(nearestHalfTimeOut(dateTime));
    setState(() {});
  }

  buildDateTimeOut1(DateTime dateTime) {
    dateTimeOut = nearestHalfTimeIn(dateTime);
    print(dateTimeOut);
    timeOut = DateFormat.jm().format(nearestHalfTimeIn(dateTime)).toString();
    dateOut = DateFormat.MMMEd().format(nearestHalfTimeIn(dateTime));
    setState(() {});
  }

  findDiffrenceTime() {
    Duration diff = dateTimeIn.difference(dateTimeOut);
    diffrence = diff.inHours.abs();
  }

  showDateTimePickerIn() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            minimumDate: nearestHalfTimeIn(DateTime.now()),
            initialDateTime: dateTimeIn,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime date) {
              buildDateTimeIn(date);
              findDiffrenceTime();
              calculateAmount(time, price);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  showDateTimePickerOut() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            minimumDate: nearestHalfTimeOut(DateTime.now()),
            initialDateTime: dateTimeOut,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime date) {
              buildDateTimeOut1(date);
              findDiffrenceTime();
              calculateAmount(time, price);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  showAddVehicle() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(
                20,
              ),
              margin: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    child: Text(
                      "Enter your Vehicle Number",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {},
                      textAlign: TextAlign.center,
                      controller: rcNu,
                      decoration: InputDecoration(
                        hintText: 'GJ 0X HX XX07',
                        filled: true,
                        fillColor: Colors.indigo[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.lightbulb_sharp,
                          color: Colors.yellow,
                          size: 10,
                        ),
                        Text(
                          "We will fetch all your vehicle details for you. Just add your vehicle in 1 click.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: MyTheme.ligthBluishColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: const Text(
                          "ADD VEHICLE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          var msg1 =
                              "This vehicle is already added in vehicle master list.";
                          var msg2 = "Please Enter a valid Vehicle Number.";
                          FocusScope.of(context).requestFocus(FocusNode());
                          changeButton = true;
                          setState(() {});
                          Navigator.of(context).pop();
                          await addNewVehicle(rcNu.text.toUpperCase())
                              ? showSnackBar1(msg1)
                              : await getVehicleDetails(rcNu.text.toUpperCase())
                                  ? null
                                  : showSnackBar1(msg2);
                          changeButton = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showVehicles() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firebase
                        .collection('users')
                        .doc(user!.phoneNumber.toString().replaceAll('+91', ''))
                        .collection('vehicles')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[i];
                                return x['registration_number'] == 'null'
                                    ? Container()
                                    : widget.type == 'both'
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  vehicleSelected = true;
                                                  vehicleName =
                                                      x['manufacturer_model'];
                                                  vehicleType =
                                                      x['vehicle_type'];
                                                  rcNo =
                                                      x['registration_number'];
                                                  time = x['vehicle_type'] ==
                                                          'Bike'
                                                      ? bikeTime
                                                      : carTime;
                                                  price = x['vehicle_type'] ==
                                                          'Bike'
                                                      ? priceBike
                                                      : priceCar;
                                                  calculateAmount(time, price);
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                                child: Widgets.vehicleCard(
                                                    x['manufacturer_model'],
                                                    x['manufacturer'],
                                                    x['vehicle_type']),
                                              )
                                            ],
                                          )
                                        : widget.type == 'bike'
                                            ? x['vehicle_type'] == 'Bike'
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          vehicleSelected =
                                                              true;
                                                          vehicleName = x[
                                                              'manufacturer_model'];
                                                          vehicleType =
                                                              x['vehicle_type'];
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                        child: Widgets.vehicleCard(
                                                            x['manufacturer_model'],
                                                            x['manufacturer'],
                                                            x['vehicle_type']),
                                                      )
                                                    ],
                                                  )
                                                : Container()
                                            : x['vehicle_type'] == 'Car'
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          vehicleSelected =
                                                              true;
                                                          vehicleName = x[
                                                              'manufacturer_model'];
                                                          vehicleType =
                                                              x['vehicle_type'];
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                        },
                                                        child: Widgets.vehicleCard(
                                                            x['manufacturer_model'],
                                                            x['manufacturer'],
                                                            x['vehicle_type']),
                                                      )
                                                    ],
                                                  )
                                                : Container();
                              },
                            )
                          : Container();
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showAddVehicle();
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Colors.indigo,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add Vehicle",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSnackBar1(msg) {
    final snackBar1 = Widgets.showSnackBar(msg);
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: vehicleSelected
          ? Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "₹ $amount",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyTheme.ligthBluishColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: const Text(
                          "BOOK NOW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          Uuid uuid = const Uuid();
                          var bookingId = DateTime.now().toString() + uuid.v4();
                          var bookingDate =
                              DateFormat.MMMEd().format(DateTime.now());
                          var bookingTime =
                              DateFormat.jm().format(DateTime.now());
                          var msg1 = "No Available space this time.";
                          var msg2 = "Booking Already Exists.";
                          FocusScope.of(context).requestFocus(FocusNode());
                          changeButton = true;
                          setState(() {});
                          calculateAmount(time, price);

                          checkPreviousParking(
                                  rcNo, dateIn, dateTimeIn, dateTimeOut)
                              .then((value) {
                            if (value) {
                              if (vehicleType == 'Bike') {
                                if (int.parse(availableSpaceBike) > 0) {
                                  bookParkingSpot(
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
                                      imageUrl);

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookingDetailsScreen(
                                        projectId: projectId,
                                        bookingId: bookingId,
                                      ),
                                    ),
                                  );
                                } else if (int.parse(availableSpaceCar) > 0) {
                                  bookParkingSpot(
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
                                      imageUrl);

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookingDetailsScreen(
                                        projectId: projectId,
                                        bookingId: bookingId,
                                      ),
                                    ),
                                  );
                                } else {
                                  showSnackBar1(msg1);
                                }
                              }
                            } else {
                              showSnackBar1(msg2);
                            }
                          });

                          changeButton = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: 0,
            ),
      body: changeButton
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: lo.LottieBuilder.asset(
                  "assets/animation/car-loader.json",
                  height: 100,
                  width: 100,
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firebase.collection('parking-space').snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, i) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              name = x['name'];
                              availableSpaceBike = x['availableSpaceBike'];
                              availableSpaceCar = x['availableSpaceCar'];
                              imageUrl = x['imageUrl'];
                              logoUrl = x['logoUrl'];
                              lat = double.parse(x['lat']);
                              long = double.parse(x['long']);
                              priceBike = x['priceBike'];
                              priceCar = x['priceCar'];
                              projectId = x['projectId'];
                              areaName = x['areaName'];
                              bikeTime = x['bikeTime'];
                              carTime = x['carTime'];
                              address = x['address'];
                              return long == 0.0
                                  ? BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Center(
                                        child: lo.LottieBuilder.asset(
                                          "assets/animation/car-loader.json",
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    )
                                  : widget.projectId == projectId
                                      ? Column(
                                          children: [
                                            Stack(
                                              children: [
                                                FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/images/default.gif",
                                                  image: imageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: (() {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(Icons
                                                              .navigate_before),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            name,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            areaName,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Expanded(
                                                        child: SizedBox(
                                                          width: 10,
                                                        ),
                                                      ),
                                                      const CircleAvatar(
                                                        child:
                                                            Icon(Icons.near_me),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.share_location,
                                                        size: 20,
                                                        color: Colors.indigo,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${widget.distance} KM",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      const Icon(
                                                        Icons.two_wheeler,
                                                        size: 20,
                                                        color: Colors.indigo,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "₹ $priceBike /$bikeTime hr",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      const Icon(
                                                        Icons.directions_car,
                                                        size: 20,
                                                        color: Colors.indigo,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "₹ $priceCar /$carTime hr",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    "When Do You Want To Park?",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: (() {
                                                              showDateTimePickerIn();
                                                            }),
                                                            child: SizedBox(
                                                              height: 100,
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                    "In",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    timeIn,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    dateIn,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .indigo[
                                                                          400],
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_outlined,
                                                            size: 20,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: (() {
                                                              showDateTimePickerOut();
                                                            }),
                                                            child: SizedBox(
                                                              height: 100,
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                    "Out",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    timeOut,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    dateOut,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .indigo[
                                                                          400],
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    vehicleSelected
                                                        ? vehicleName
                                                        : "No vehicle selected",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showVehicles();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                      ),
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      child: vehicleSelected
                                                          ? Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    vehicleName,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .indigo,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  vehicleType,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .indigo,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                const Icon(
                                                                  Icons
                                                                      .arrow_drop_down_circle_outlined,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .indigo,
                                                                ),
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Icon(
                                                                  Icons
                                                                      .arrow_drop_down_circle_outlined,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .indigo,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "Select Vehicle",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .indigo,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    "Highlights",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.verified_user,
                                                        size: 15,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        "Secured Parking",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    height: 300,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: GoogleMap(
                                                        zoomControlsEnabled:
                                                            false,
                                                        myLocationButtonEnabled:
                                                            false,
                                                        initialCameraPosition:
                                                            CameraPosition(
                                                          target:
                                                              LatLng(lat, long),
                                                          zoom: 15,
                                                        ),
                                                        onMapCreated:
                                                            (controller) {
                                                          setState(() {});
                                                        },
                                                        markers: {
                                                          Marker(
                                                            markerId:
                                                                const MarkerId(
                                                                    "value"),
                                                            position: LatLng(
                                                                lat, long),
                                                            onTap: () {},
                                                            // icon: (mkIcon == null)
                                                            //     ? BitmapDescriptor.defaultMarker
                                                            //     : mkIcon,
                                                          )
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container();
                            }))
                        : Container();
                  },
                ),
              ),
            ),
    );
  }
}
