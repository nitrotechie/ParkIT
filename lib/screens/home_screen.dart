import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  var searching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
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
      body: SafeArea(child: SingleChildScrollView()),
      
    );
  }
}
