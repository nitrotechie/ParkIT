import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkit/screens/register_screen.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';
import 'package:parkit/widgets/otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phno = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var changeButton = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/logo.gif',
                          scale: 1.4,
                        ),
                        LottieBuilder.asset(
                          "assets/animation/park.json",
                          height: 300,
                          width: 300,
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
                                height: 10,
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
                                height: 20,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  width: MediaQuery.of(context).size.width,
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
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_formKey.currentState!.validate()) {
                                        changeButton = true;
                                        setState(() {
                                          Data.phno = phno.text;
                                        });
                                        await isPhoneRegistered(phno.text)
                                            ? Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const OTPScreen()))
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterScreen()));
                                        changeButton = false;
                                        // showOTPDialog();

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
    );
  }
}
