import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static String date = "";
  static String place = "";
  static String description = "";

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                dateString: date,
                placeString: place,
                descriptionString: description,
              )),
    );
  }

  Future<Text> fetchData() async {
    await Firebase.initializeApp();
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Meeting').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) date = "Error fetching data";

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            for (int i = 0; i < docs.length; i++) {
              final data = docs[i].data();
              date = data['date'];
              place = data['place'];
              description = data['description'];
              print("Suca ${data}");
            }
          }
          return const Text("Loading...");
        });
    return const Text("Loading...");
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: Center(
            child: Image.asset(
              "assets/loading.gif",
              //height: 125.0,
              //width: 125.0,
            ),
          ),
        ));
  }
}
