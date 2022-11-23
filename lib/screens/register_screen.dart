import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/otp.dart';
import 'package:parkit/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phno = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var changeButton = false;

  @override
  void initState() {
    super.initState();
    phno.text = Data.phno == "" ? phno.text : Data.phno;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
          body: SafeArea(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "In less than a minute",
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
                              "assets/animation/registration.json",
                              height: 200,
                              width: 200,
                            ),
                          ],
                        )),
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
                                  height: 10,
                                ),
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: name,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
                                  ),
                                  validator: (value) {
                                    if (value == "") {
                                      return "Please Enter Your Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Email Address",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Email Address",
                                  ),
                                  validator: (value) {
                                    if (value == "") {
                                      return "Please Enter Your Email Address";
                                    } else if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value!)) {
                                      return "Please Enter A Valid Email Address";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
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
                                Row(
                                  children: [
                                    const Text(
                                      "+91",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        controller: phno,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Phone Number",
                                        ),
                                        validator: (value) {
                                          if (value == "") {
                                            return "Please Enter Your Phone Number";
                                          } else if (value!.length != 10) {
                                            return "Please Enter A Valid Phone Number";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    decoration: BoxDecoration(
                                      color: MyTheme.ligthBluishColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      child: const Text(
                                        "CONTINUE",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final snackBar = Widgets.showSnackBar(
                                            "Something Went Wrong!......");
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (_formKey.currentState!.validate()) {
                                          Data.userName = name.text;
                                          Data.phno = phno.text;
                                          Data.userEmail = email.text;
                                          changeButton = true;
                                          setState(() {});
                                          await registerUser()
                                              ? Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const OTPScreen()))
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                          changeButton = false;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
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
    );
  }
}
