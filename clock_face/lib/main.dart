import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ClockFace(),
    );
  }
}

class ClockFace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClockFaceState();
  }
}

class ClockFaceState extends State<ClockFace> {
  DateTime now;
  DateFormat formatter = DateFormat('HH:mm:ss');
  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text( formatter.format(now), style: TextStyle( fontSize: 64 ), )
      ),
    );
  }
}
