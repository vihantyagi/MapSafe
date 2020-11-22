import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About_Us  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 55.0),
            child: Text(
              'About Us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 20.0),
        child: Text(
          "Hey guys! We from MapSafe hope you're doing well in these tough times. Your safety is our number one priority. Our team right now includes... well me (Vihan Tyagi) and Raghuvamsi Kunchala. We are final year computer science Students from Bennett University and we've made this app as part of our Capstone Project using Here Technologies Flutter SDK on Android Studio! We've worked hard on this project and we hope you like it.",
          style: TextStyle(
            fontFamily: 'SecularOne',
            fontSize: 19.0,
          ),
        ),
      ),
    );
  }
}