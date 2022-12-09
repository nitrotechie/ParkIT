import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lo;
import 'package:parkit/screens/parking_spot_screen.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/methods.dart';
import 'package:parkit/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  var searching = false;
  var loading = false;
  var mkIcon;
  @override
  void initState() {
    super.initState();
    getUserName();
    getImage();
    getCurrentPosition();
    getIcon();
  }

  getUserName() async {
    await Data.getUsername();
  }

  getImage() async {
    await Data.getImage();
  }

  static double lati = 0.0;
  static double lon = 0.0;

  getCurrentPosition() async {
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
        getCurrentPosition();
      }
    } else {
      Position currentPostion = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      lati = currentPostion.latitude;
      lon = currentPostion.longitude;
      setState(() {});
    }
  }

  getIcon() async {
    mkIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/coupe.png",
    );
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: (Data.image == "" || Data.image == "null")
                        ? const Icon(Icons.person)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(23),
                            child: Image.network(Data.image),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              Methods.greeting(),
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Methods.greetingIcon(),
                          ],
                        ),
                        Text(
                          Data.userName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: lon == 0.0
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Book Your Parking Now,",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
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
                              target: LatLng(lati, lon), zoom: 15),
                          onMapCreated: (controller) {
                            setState(() {});
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId("value"),
                              position: LatLng(lati, lon),
                              onTap: () {},
                              // icon: (mkIcon == null)
                              //     ? BitmapDescriptor.defaultMarker
                              //     : mkIcon,
                            )
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Nearby Parking spot",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: firebase
                                      .collection('parking-space')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, i) {
                                              QueryDocumentSnapshot x =
                                                  snapshot.data!.docs[i];
                                              String name = x['name'];
                                              String availableSpaceBike =
                                                  x['availableSpaceBike'];
                                              String availableSpaceCar =
                                                  x['availableSpaceCar'];
                                              String imageUrl = x['imageUrl'];
                                              String logoUrl = x['logoUrl'];
                                              String lat = x['lat'];
                                              String long = x['long'];
                                              String priceBike = x['priceBike'];
                                              String priceCar = x['priceCar'];
                                              String projectId = x['projectId'];
                                              String type = x['type'];
                                              String distance =
                                                  (Geolocator.distanceBetween(
                                                            lati,
                                                            lon,
                                                            double.parse(lat),
                                                            double.parse(long),
                                                          ) /
                                                          1000)
                                                      .toStringAsFixed(2)
                                                      .toString();
                                              return
                                                  //  double.parse(distance) < 25   ?
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: GestureDetector(
                                                  onTap: (() {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ParkingSpotScreen(
                                                          projectId: projectId,
                                                          distance: distance,
                                                          type: type,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.indigo[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    "assets/images/default.gif",
                                                                image: logoUrl,
                                                                height: 100,
                                                                width: 100,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  name,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .currency_rupee,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .indigo,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      priceBike ==
                                                                              ""
                                                                          ? priceCar
                                                                          : priceBike,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .share_location,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .indigo,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      "$distance KM",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    int.parse(availableSpaceBike) >
                                                                            0
                                                                        ? const Icon(
                                                                            Icons.two_wheeler,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.indigo,
                                                                          )
                                                                        : const SizedBox(),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    int.parse(availableSpaceCar) >
                                                                            0
                                                                        ? const Icon(
                                                                            Icons.directions_car,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.indigo,
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                        : const Text(
                                            "No, Nearby Parking spot",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      // : Stack(
      //     children: [
      //       GoogleMap(
      //         myLocationButtonEnabled: false,
      //         initialCameraPosition: CameraPosition(
      //             target: LatLng(lat, lon), zoom: 15),
      //         onMapCreated: (controller) {
      //           setState(() {});
      //         },
      //         markers: {
      //           Marker(
      //             markerId: const MarkerId("value"),
      //             position: LatLng(lat, lon),
      //             onTap: () {},
      //             // icon: (mkIcon == null)
      //             //     ? BitmapDescriptor.defaultMarker
      //             //     : mkIcon,
      //           )
      //         },
      //       ),
      //       SafeArea(
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: Container(
      //                 margin: const EdgeInsets.only(
      //                   left: 12,
      //                   right: 10,
      //                   top: 10,
      //                 ),
      //                 height: 50,
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //                 child: TextField(
      //                   controller: search,
      //                   textAlign: TextAlign.justify,
      //                   decoration: InputDecoration(
      //                     border: InputBorder.none,
      //                     prefixIcon: Icon(
      //                       Icons.search,
      //                       size: 25,
      //                       color: Theme.of(context).secondaryHeaderColor,
      //                     ),
      //                     suffixIcon: searching
      //                         ? IconButton(
      //                             icon: Icon(
      //                               Icons.cancel,
      //                               size: 25,
      //                               color: Theme.of(context)
      //                                   .secondaryHeaderColor,
      //                             ),
      //                             onPressed: () {
      //                               setState(() {
      //                                 search.text = "";
      //                               });
      //                             },
      //                           )
      //                         : Container(),
      //                     hintText: "Search",
      //                   ),
      //                   onChanged: (value) {
      //                     if (value != "") {
      //                       setState(() {
      //                         searching = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         searching = false;
      //                       });
      //                     }
      //                   },
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               margin: const EdgeInsets.only(
      //                 right: 12,
      //                 top: 10,
      //               ),
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               child: IconButton(
      //                 onPressed: () {},
      //                 icon: const Icon(
      //                   Icons.tune,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
    );
  }
}
