import 'package:flutter/material.dart';
import 'package:parkit/screens/account_screen.dart';
import 'package:parkit/screens/booking_sceen.dart';
import 'package:parkit/screens/home_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  var myIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    const BookingScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_parking,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.manage_accounts,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
