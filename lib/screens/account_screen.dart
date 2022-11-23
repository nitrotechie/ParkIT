import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkit/screens/address_screen.dart';
import 'package:parkit/screens/faq_screen.dart';
import 'package:parkit/screens/privacy_policy_screen.dart';
import 'package:parkit/screens/profile_screen.dart';
import 'package:parkit/screens/support_screen.dart';
import 'package:parkit/screens/vehicle_screen.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
    getUserName();
  }

  getUserName() async {
    await Data.getUsername();
  }

  getImage() async {
    await Data.getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.indigo.withOpacity(0.1),
        title: const Text(
          "Account",
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
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
                  }),
                  child: Container(
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
                              Text(
                                Data.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "My Profile",
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                boxShadow: MyTheme.neumorpShadow,
                                borderRadius: BorderRadius.circular(10)),
                            child: (Data.image == "" || Data.image == "null")
                                ? const Icon(Icons.person)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    child: Image.network(Data.image),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: (() {}),
                      child: Container(
                        color: Colors.indigo.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 0,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
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
                                          "Wallet",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Quick Payments",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹ ${Data.balance}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                )
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
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Widgets.accountCard(
                        context,
                        VehicleScreen(),
                        Icons.directions_car_outlined,
                        "Vehicle",
                        "Add Vehicle Information",
                      ),
                      Widgets.accountCard(
                        context,
                        AddressScreen(),
                        Icons.location_on_outlined,
                        "My Addresses",
                        "Pre Saved Address",
                      ),
                      Widgets.accountCard(
                        context,
                        const SupportScreen(),
                        Icons.help_outline_outlined,
                        "Support",
                        "Contact us for issue & feedback",
                      ),
                      Widgets.accountCard(
                        context,
                        const PrivacyScreen(),
                        Icons.policy_outlined,
                        "Privacy Policy",
                        "Know our privacy policy",
                      ),
                      Widgets.accountCard(
                        context,
                        const FAQScreen(),
                        Icons.quiz_outlined,
                        "FAQs",
                        "Get your questions answers",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
