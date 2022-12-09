import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/widgets.dart';

class VehicleScreen extends StatefulWidget {
  VehicleScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  TextEditingController rcNo = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  bool changeButton = false;
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
                      controller: rcNo,
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
                          await addNewVehicle(rcNo.text.toUpperCase())
                              ? showSnackBar1(msg1)
                              : await getVehicleDetails(rcNo.text.toUpperCase())
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

  showSnackBar1(msg) {
    final snackBar1 = Widgets.showSnackBar(msg);
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "My Vehicle",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Vehicles you own",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LottieBuilder.asset(
                            "assets/animation/car.json",
                            height: 200,
                            width: 200,
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            showAddVehicle();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const AddVehicleScreen()));
                          }),
                          child: Container(
                            color: Colors.indigo.withOpacity(0.1),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              decoration: BoxDecoration(
                                color: MyTheme.ligthBluishColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Add New Vehicle",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 90,
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        20,
                        20,
                        20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firebase
                            .collection('users')
                            .doc(user!.phoneNumber
                                .toString()
                                .replaceAll('+91', ''))
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
                                        ? Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 200),
                                            child: LottieBuilder.asset(
                                                "assets/animation/nodata.json"),
                                          )
                                        : Widgets.vehicleCard(
                                            x['manufacturer_model'],
                                            x['manufacturer'],
                                            x['vehicle_type']);
                                  },
                                )
                              : Container();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          changeButton == true
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: LottieBuilder.asset(
                      "assets/animation/car-loader.json",
                      height: 100,
                      width: 100,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
