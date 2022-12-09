import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/screens/booking_details.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Bookings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<QuerySnapshot>(
            stream: firebase
                .collection('users')
                .doc(user!.phoneNumber.toString().replaceAll('+91', ''))
                .collection('bookings')
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[i];
                        return x['bookingId'] == 'null'
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 200),
                                child: LottieBuilder.asset(
                                    "assets/animation/ticket.json"),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: GestureDetector(
                                  onTap: (() {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookingDetailsScreen(
                                                projectId: x['projectId'],
                                                bookingId: x['bookingId']),
                                      ),
                                    );
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: x['bookingStatus'] == "NotActive"
                                          ? Colors.indigo[100]
                                          : Colors.green[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${x['dateIn']}, ${x['timeIn']}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    x['vehicleName'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 20,
                                                        color: Colors.grey[700],
                                                      ),
                                                      Text(
                                                        x['parkingName'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              x['vehicleType'] == 'Bike'
                                                  ? Image.asset(
                                                      "assets/images/bike.png",
                                                      height: 100,
                                                      width: 100,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/car.png",
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: x['bookingStatus'] ==
                                                    "NotActive"
                                                ? Colors.indigo[200]
                                                : Colors.green[300],
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              x['bookingStatus'] == 'Active'
                                                  ? 'ADD TIME'
                                                  : 'BOOK AGAIN',
                                              style: TextStyle(
                                                  color: x['bookingStatus'] ==
                                                          'Active'
                                                      ? Colors.white
                                                      : Colors.indigo,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.only(bottom: 200),
                      child:
                          LottieBuilder.asset("assets/animation/ticket.json"),
                    );
            },
          ),
        ),
      )),
    );
  }
}
