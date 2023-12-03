import 'dart:io';
import 'package:ugd1/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ugd1/View/login.dart';
import 'package:flutter/material.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('test login success', (widgetTester) async {
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
              builder: (context) => Loginview(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    final usernameField = find.byKey(Key('username'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('login'));

    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await widgetTester.enterText(usernameField, 'user123');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(passwordField, 'user123');
    await widgetTester.pumpAndSettle();

    // Ensure the login button is visible
    await widgetTester.ensureVisible(loginButton);
    await widgetTester.pumpAndSettle();

    // Tap the login button
    await widgetTester.tap(loginButton);
    await widgetTester.pumpAndSettle(Duration(seconds: 5));

    final home = find.byKey(Key('home'));
    expect(home, findsOneWidget);
  });

  testWidgets('test login failed', (widgetTester) async {
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
              builder: (context) => Loginview(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    final usernameField = find.byKey(Key('username'));
    final passwordField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('login'));

    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await widgetTester.enterText(usernameField, 'user000'); //ga ada di database
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(passwordField, 'user000');
    await widgetTester.pumpAndSettle();

    // Ensure the login button is visible
    await widgetTester.ensureVisible(loginButton);
    await widgetTester.pumpAndSettle();

    // Tap the login button
    await widgetTester.tap(loginButton);

    int maxDuration = 10;
    // Maximum duration to check for the Snackbar (adjust as needed)
    bool snackbarFound = false;

    // Loop to check for the presence of the Snackbar with an incrementing duration
    for (int duration = 1; duration <= maxDuration; duration++) {
      await widgetTester.pumpAndSettle(const Duration(seconds: 1));
      if (find.text('Login Failed').evaluate().isNotEmpty) {
        snackbarFound = true;
        break;
      }
    }

    // Verify that the Snackbar is displayed
    expect(snackbarFound, isTrue);
  });
}

class MyScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
