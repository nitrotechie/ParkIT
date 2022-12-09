import 'package:flutter/material.dart';
import 'package:parkit/utils/themes.dart';

class Widgets {
  static accountCard(BuildContext context, Widget nextScreen, IconData icon,
      String title, String subTitle) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => nextScreen));
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                color: MyTheme.ligthBluishColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static vehicleCard(String title, String subTitle, String bikeOrCar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        bikeOrCar == 'Bike'
            ? Image.asset(
                "assets/images/bike.png",
                height: 100,
                width: 100,
              )
            : Image.asset(
                "assets/images/car.png",
                height: 100,
                width: 100,
              ),
      ],
    );
  }

  static SnackBar showSnackBar(String msg) {
    return SnackBar(
      content: Text(
        msg,
      ),
      action: SnackBarAction(
        label: "Ok",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
