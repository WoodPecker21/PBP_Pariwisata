import 'package:flutter/material.dart';
import 'package:ugd1/View/home.dart';
import 'package:ugd1/View/register.dart';
import 'package:ugd1/component/form_component.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const LoginView());

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
