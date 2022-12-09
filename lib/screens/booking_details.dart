import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lo;
import 'package:parkit/utils/themes.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String projectId;
  final String bookingId;
  const BookingDetailsScreen({
    super.key,
    required this.projectId,
    required this.bookingId,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool changeButton = false;

  showQrImage(data) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: QrImage(data: data),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  stream: firebase
                      .collection('users')
                      .doc(user!.phoneNumber.toString().replaceAll('+91', ''))
                      .collection('bookings')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, i) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              if (widget.bookingId == x['bookingId']) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 35, 25, 35),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: lo.LottieBuilder.asset(
                                                "assets/animation/book_load.json",
                                                height: 150,
                                                width: 150,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30, bottom: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo[100],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child:
                                                      const Icon(Icons.close),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Text(
                                          "Booking Details",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 35,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Parking Slot",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['spot'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 35,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Vehicle Name",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          x['vehicleName'],
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                        "Vehicle Number",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['rcNo'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showQrImage(x['rcNo']);
                                                    },
                                                    child: QrImage(
                                                      data: x['rcNo'],
                                                      size: 150,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Divider(
                                                thickness: 1.0,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Entry After",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['timeIn'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['dateIn'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_outlined,
                                                  ),
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Exit Before",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['timeOut'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['dateOut'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Divider(
                                                thickness: 1.0,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "Entrance Address",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          x['address'],
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/images/default.gif",
                                                      image: x['imageUrl'],
                                                      fit: BoxFit.cover,
                                                      placeholderFit:
                                                          BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: MyTheme
                                                          .ligthBluishColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                            Icons.near_me,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "GET DIRECTIONS",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }))
                        : Container();
                  },
                ),
              ),
            ),
    );
  }
}
