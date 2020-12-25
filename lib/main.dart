import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(), // Initialize FlutterFire
        builder: (context, snapshot) {
          return MaterialApp(
            home: new HomePage(),
          );
        });
  }
}
