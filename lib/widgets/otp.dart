import 'package:flutter/material.dart';
import 'package:parkit/services/services.dart';
import 'package:parkit/utils/themes.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKeyOTP = GlobalKey<FormState>();
  var changeButton = false;
  final TextEditingController otp = TextEditingController();
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Verification",
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
                        Image.asset(
                          'assets/images/ver.png',
                          gaplessPlayback: false,
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
                        key: _formKeyOTP,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "We've sent an OTP on mobile number ${Data.phno}",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                                          "GET STARTED",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (_formKeyOTP.currentState!.validate()) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
