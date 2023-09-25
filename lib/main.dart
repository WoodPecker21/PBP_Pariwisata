import 'package:flutter/material.dart';
//import 'package:ugd1/View/home.dart';
import 'package:ugd1/View/login.dart';
//import 'package:ugd1/View/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginView(),
    );
  }
}
