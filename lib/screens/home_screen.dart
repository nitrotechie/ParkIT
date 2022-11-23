import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/services/services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  var searching = false;
  var mkIcon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data.getCurrentPosition(context);
    getIcon();
  }

  getIcon() async {
    mkIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/coupe.png",
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(Data.lat, Data.lon), zoom: 15),
            markers: {
              Marker(
                markerId: const MarkerId("value"),
                position: LatLng(Data.lat, Data.lon),
                infoWindow: const InfoWindow(
                  title: "Title",
                  snippet: "Snippets",
                ),
                icon:
                    (mkIcon == null) ? BitmapDescriptor.defaultMarker : mkIcon,
              )
            },
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 12,
                      right: 10,
                      top: 10,
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: search,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        suffixIcon: searching
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 25,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    search.text = "";
                                  });
                                },
                              )
                            : Container(),
                        hintText: "Search",
                      ),
                      onChanged: (value) {
                        if (value != "") {
                          setState(() {
                            searching = true;
                          });
                        } else {
                          setState(() {
                            searching = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 12,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.tune,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
