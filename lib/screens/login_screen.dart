import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkit/screens/register_screen.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phno = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  var changeButton = false;

  showOTPDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3,
              bottom: MediaQuery.of(context).size.height / 3,
              left: 30,
              right: 30,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKeyOTP,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "OTP",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            controller: otp,
                            decoration: const InputDecoration(
                              hintText: "Enter Your OTP",
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Your OTP";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Container(
                            width: changeButton == true
                                ? 40
                                : MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              color: MyTheme.ligthBluishColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              child: changeButton == true
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    changeButton == true;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyTheme.ligthBluishColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Image.asset("assets/images/facebook.png"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Facebook",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "|",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Image.asset("assets/images/google.png"),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/logo.gif',
                      scale: 1.4,
                    ),
                    Image.asset(
                      'assets/images/sp.png',
                      scale: 1.4,
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              "Sign In Now",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phno,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Phone Number",
                            ),
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Your Phone Number";
                              } else if (!RegExp(
                                      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                                  .hasMatch(value!)) {
                                return "Please Enter A Valid Phone Number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Container(
                              width: changeButton == true
                                  ? 40
                                  : MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: MyTheme.ligthBluishColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                child: changeButton == true
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "CONTINUE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      changeButton == true;
                                      Data.phno = phno.text;
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                    // showOTPDialog();

                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              "Or Continue With",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
