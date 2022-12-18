import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final String rcNo;
  final String vehicleType;
  const VehicleDetailsScreen({
    super.key,
    required this.rcNo,
    required this.vehicleType,
  });

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return widget.rcNo == x['registration_number']
                        ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.indigo[500],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      onPressed: (() {
                                        Navigator.pop(context);
                                      }),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              x['manufacturer_model'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['registration_number'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['owner_name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        x['vehicle_type'] == 'Bike'
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
                                    )
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 350,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 130,
                                              width: 330,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    child: const Icon(
                                                      Icons.document_scanner,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Insurance',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Expiry Date: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['insurance_validity'] ?? 'Not Available',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Insurance name: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 180,
                                                        child: Text(
                                                          x['insurance_name'] ?? 'Not Available',
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        height: 130,
                                        width: 350,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 130,
                                              width: 330,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    child: const Icon(
                                                      Icons.document_scanner,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'Pollution Certificate',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Expiry Date: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Text(
                                                        x['puc_valid_upto'] ?? 'Not Available',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'PUC Number: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 180,
                                                        child: Text(
                                                          x['puc_number'] ?? 'Not Available',
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Manufacturer",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['manufacturer'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Fuel Type",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['fuel_type'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Norms Type",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['norms_type'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Fitness Upto",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['fitness_upto'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Chassis number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['chassis_number'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Owner Serial Number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['owner_serial_number'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Registered Place",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                x['registered_place'] ?? 'Not Available',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Registration Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              x['registration_date'] ?? 'Not Available',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Current Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                x['current_address'] ?? 'Not Available',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              "Permanent Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                x['permanent_address'] ?? 'Not Available',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        : Container();
                  },
                )
              : Container();
        },
      )),
    );
  }
}
