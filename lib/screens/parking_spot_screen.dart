import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lo;
import 'package:intl/intl.dart';

class ParkingSpotScreen extends StatefulWidget {
  final String projectId;
  final String distance;
  const ParkingSpotScreen(
      {super.key, required this.projectId, required this.distance});

  @override
  State<ParkingSpotScreen> createState() => _ParkingSpotScreenState();
}

class _ParkingSpotScreenState extends State<ParkingSpotScreen> {
  final firebase = FirebaseFirestore.instance;
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
  int diffrence = 1;
  DateTime dateTimeIn = DateTime.now();
  DateTime dateTimeOut = DateTime.now();
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    getParkingDetails(widget.projectId);
    buildDateTimeIn(dateTime);
    buildDateTimeOut(dateTime);
    findDiffrenceTime();
  }

  getParkingDetails(String projectId) {
    final docRef = firebase.collection("parking-space").doc(projectId);
    docRef.snapshots().listen(
      (event) {
        Map<String, dynamic> x = event.data() as Map<String, dynamic>;
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
        setState(() {});
      },
      onError: (e) {},
    );
  }

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

  findDiffrenceTime() {
    Duration diff = dateTimeIn.difference(dateTimeOut);
    diffrence = diff.inHours.abs();
  }

  showDateTimePickerIn(initialDate) {
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
            initialDateTime: initialDate,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime date) {
              buildDateTimeIn(date);
              findDiffrenceTime();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  showDateTimePickerOut(initialDate) {
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
            initialDateTime: initialDate,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime date) {
              buildDateTimeOut(date);
              findDiffrenceTime();
              setState(() {});
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: long == 0.0
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
                child: Column(
                  children: [
                    Stack(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "assets/images/default.gif",
                          image: imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.navigate_before),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    areaName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
                                child: Icon(Icons.near_me),
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
                                  fontWeight: FontWeight.bold,
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
                                  fontWeight: FontWeight.bold,
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
                                  fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (() {
                                      showDateTimePickerIn(
                                          nearestHalfTimeIn(dateTimeIn));
                                    }),
                                    child: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "In",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            timeIn,
                                            style: const TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            dateIn,
                                            style: TextStyle(
                                              color: Colors.indigo[400],
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 20,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (() {
                                      showDateTimePickerOut(
                                          nearestHalfTimeOut(dateTimeOut));
                                    }),
                                    child: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Out",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            timeOut,
                                            style: const TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            dateOut,
                                            style: TextStyle(
                                              color: Colors.indigo[400],
                                              fontSize: 20,
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
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 15,
                                ),
                                onMapCreated: (controller) {
                                  setState(() {});
                                },
                                markers: {
                                  Marker(
                                    markerId: const MarkerId("value"),
                                    position: LatLng(lat, long),
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
                ),
              ),
            ),
    );
  }
}
