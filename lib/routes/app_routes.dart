import 'package:flutter/material.dart';
import 'package:ugd1/View/landing_page_screen.dart';
import 'package:ugd1/View/login.dart';
import 'package:ugd1/View/home.dart';
import 'package:ugd1/View/register.dart';
import 'package:ugd1/View/privacyPolicyPage.dart';

class AppRoutes {
  static const String landingPageScreen = '/landing_page_screen';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String privasiPage = '/privacyPolicyPage';

  static Map<String, WidgetBuilder> routes = {
    landingPageScreen: (context) => const LandingPageScreen(),
    login: (context) => const Loginview(),
    home: (context) => const HomeView(),
    register: (context) => const RegisterPage(),
    privasiPage: (context) => PrivacyPolicyPage(),
  };
}
