import 'package:flutter/material.dart';
//import 'package:ugd1/View/home.dart';
import 'package:ugd1/View/login.dart';
//import 'package:ugd1/View/register.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool _iconbool = false;

IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.nights_stay;

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.dark,
);

class _MyHomePageState extends State<MyHomePage> {
  ThemeData _currentTheme = lightTheme;

  void _toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == lightTheme ? darkTheme : lightTheme;
      _iconbool = !_iconbool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          child: const Icon(Icons.wb_sunny),
        ),
        body: LoginView(),
     ),
);
}
}