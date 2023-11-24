import 'package:flutter/material.dart';
import 'package:ugd1/View/landing_page_screen.dart';
import 'package:ugd1/View/login.dart';
import 'package:ugd1/View/home.dart';
import 'package:ugd1/View/register.dart';
import 'package:ugd1/View/privacyPolicyPage.dart';
import 'package:ugd1/View/booking1.dart';
import 'package:ugd1/View/booking2.dart';
import 'package:ugd1/View/booking3.dart';
import 'package:ugd1/View/booking_sukses.dart';
import 'package:ugd1/View/PaymentPage.dart';
import 'package:ugd1/View/inputPage.dart';

class AppRoutes {
  static const String landingPageScreen = '/landing_page_screen';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String privasiPage = '/privacyPolicyPage';
  static const String booking1 = '/booking1';
  static const String booking2 = '/booking2';
  static const String booking3 = '/booking3';
  static const String bookingSukses = '/booking_sukses';
  static const String paymentPage = '/PaymentPage';
  static const String inputPage = '/inputPage';

  static Map<String, WidgetBuilder> routes = {
    landingPageScreen: (context) => const LandingPageScreen(),
    login: (context) => const Loginview(),
    home: (context) => const HomeView(),
    register: (context) => const RegisterPage(),
    privasiPage: (context) => PrivacyPolicyPage(),
    booking1: (context) => const Booking1Page(),
    booking2: (context) => const Booking2Page(),
    booking3: (context) => const Booking3Page(),
    bookingSukses: (context) => const BookingSukses(),
    paymentPage: (context) => const PaymentPage(),
    inputPage: (context) => const InputPage(),
  };
}