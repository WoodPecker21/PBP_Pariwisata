import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
import 'package:ugd1/View/forgotpassword.dart';
import 'package:ugd1/View/User/homeUser.dart';
import 'package:ugd1/View/profil.dart';
import 'package:ugd1/View/news.dart';
import 'package:ugd1/View/newsUser.dart';
import 'package:ugd1/View/editBooking.dart';
import 'package:ugd1/View/editBookingSukses.dart';
import 'package:ugd1/View/ShowBooking.dart';

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
  static const String forgotpassword = '/forgotpassword';
  static const String homeUser = '/User/homeUser';
  static const String profil = '/profil';
  static const String newsPageInput = '/newsPageInput';
  static const String newsPage = '/newsPage';
  static const String editBooking = '/editBooking';
  static const String editBookingSukses = '/editBookingSukses';
  static const String showBooking = '/ShowBooking';

  static Map<String, WidgetBuilder> routes = {
    landingPageScreen: (context) => const LandingPageScreen(),
    login: (context) => const Loginview(),
    home: (context) => HomeView(),
    register: (context) => const RegisterPage(),
    privasiPage: (context) => PrivacyPolicyPage(),
    booking1: (context) => const Booking1Page(),
    booking2: (context) => const Booking2Page(),
    booking3: (context) => const Booking3Page(),
    bookingSukses: (context) => const BookingSukses(),
    paymentPage: (context) => const PaymentPage(),
    inputPage: (context) => const InputPage(),
    forgotpassword: (context) => const ForgotPasswordPage(),
    homeUser: (context) => HomePage(),
    profil: (context) => const Profile(),
    newsPageInput: (context) => const NewsPageInput(),
    editBooking: (context) => const EditBooking(),
    editBookingSukses: (context) => const EditBookingSukses(),
    showBooking: (context) => BookingView(),
    // newsPage: (context) => const NewsPage(),
  };
}
