import 'package:flutter/material.dart';
import 'package:parkit/utils/themes.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController vehName = TextEditingController();
  final TextEditingController regNo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String dropdownvalue = 'Hatchback';

  var items = [
    'Hatchback',
    'Sedan',
    'Pickup',
    'SUV',
    'Coupe',
  ];

  var changeButton = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.indigo.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Add Vehicle",
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
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vehicle Type",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "assets/images/${dropdownvalue.toLowerCase()}.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Vehicle Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: vehName,
                    decoration: const InputDecoration(
                      hintText: "Enter Vehicle Name",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please Enter Vehicle Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Vehicle Reg. Number",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: regNo,
                    decoration: const InputDecoration(
                      hintText: "Enter Vehicle Registration Number",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please Enter Vehicle Registration Number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
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
                              "SAVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            changeButton == true;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
