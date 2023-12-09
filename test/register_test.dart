import 'dart:io';
import 'package:ugd1/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ugd1/View/register.dart';
import 'package:flutter/material.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('test register success', (widgetTester) async {
    await widgetTester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: Scaffold(
            body: Builder(
              builder: (context) => RegisterPage(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    //----halaman register -----

    final nama = find.byKey(Key('username'));
    final email = find.byKey(Key('email'));
    final password = find.byKey(Key('password'));
    final gender = find.byKey(Key('laki'));
    final check = find.byKey(Key('check'));
    final phone = find.byKey(Key('hp'));
    final date = find.byKey(Key('tanggallahir'));
    final registerButton = find.byKey(Key('register'));

    expect(nama, findsOneWidget);
    expect(email, findsOneWidget);
    expect(password, findsOneWidget);

    await widgetTester.enterText(nama, 'John Doe');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(email, 'johndd@gmail.com');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(password, 'John Doe');
    await widgetTester.pumpAndSettle();

    //scroll
    await widgetTester.drag(
        find.byType(SingleChildScrollView), Offset(0, -500));
    await widgetTester.pumpAndSettle();

    expect(gender, findsOneWidget);
    expect(check, findsOneWidget);
    expect(phone, findsOneWidget);
    expect(date, findsOneWidget);
    expect(registerButton, findsOneWidget);

    await widgetTester.enterText(phone, '81234567890');
    await widgetTester.pumpAndSettle();

    //untuk date picker
    await widgetTester.enterText(date, '2000-03-03');
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(gender);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));

    await widgetTester.tapAt(widgetTester.getTopLeft(check));
    await widgetTester.pumpAndSettle();

    // Ensure the register button is visible
    await widgetTester.ensureVisible(registerButton);
    await widgetTester.pumpAndSettle();

    // Tap the register button
    await widgetTester.tap(registerButton);
    await widgetTester.pumpAndSettle(Duration(seconds: 5));

    final okButton = find.byKey(Key('ok'));

    expect(okButton, findsOneWidget);
    await widgetTester.tap(okButton);

    await widgetTester.pumpAndSettle(Duration(seconds: 5));

    final login = find.byKey(Key('login'));
    expect(login, findsOneWidget);
  });

  testWidgets('test register failed', (widgetTester) async {
    await widgetTester.pumpWidget(ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: Scaffold(
            body: Builder(
              builder: (context) => RegisterPage(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    //----halaman register -----

    final nama = find.byKey(Key('username'));
    final gender = find.byKey(Key('laki'));
    final phone = find.byKey(Key('hp'));
    final registerButton = find.byKey(Key('register'));

    expect(nama, findsOneWidget);

    await widgetTester.enterText(nama, 'Siti Budi');
    await widgetTester.pumpAndSettle();

    //scroll
    await widgetTester.drag(
        find.byType(SingleChildScrollView), Offset(0, -500));
    await widgetTester.pumpAndSettle();

    expect(gender, findsOneWidget);
    expect(phone, findsOneWidget);
    expect(registerButton, findsOneWidget);

    await widgetTester.enterText(phone, '81234567890');
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(gender);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));

    // Ensure the register button is visible
    await widgetTester.ensureVisible(registerButton);
    await widgetTester.pumpAndSettle();

    // Tap the register button
    await widgetTester.tap(registerButton);
    await widgetTester.pumpAndSettle(Duration(seconds: 5));
  });
}

class MyScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
