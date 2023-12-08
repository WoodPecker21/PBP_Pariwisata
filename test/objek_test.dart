import 'dart:io';
import 'package:ugd1/View/home.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('test objek success', (widgetTester) async {
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
              builder: (context) => HomeView(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    final inputButton = find.byKey(Key('inputobjek'));
    expect(inputButton, findsOneWidget);
    await widgetTester.tap(inputButton);
    await widgetTester.pumpAndSettle();

    //----halaman input -----

    final nama = find.byKey(Key('nama'));
    final deskripsi = find.byKey(Key('deskripsi'));
    final harga = find.byKey(Key('harga'));
    final akomodasi = find.byKey(Key('akomodasi'));
    final durasi = find.byKey(Key('durasi'));
    final pulau = find.byKey(Key('pulau'));
    final transportasi = find.byKey(Key('transportasi'));
    //pake rating bintang 5 (klu index kurang 1 dari bintang aslinya)
    final rating = find.byKey(Key('star4'));
    final saveButton = find.byKey(Key('simpan'));

    expect(nama, findsOneWidget);
    expect(deskripsi, findsOneWidget);
    expect(harga, findsOneWidget);
    expect(akomodasi, findsOneWidget);
    expect(durasi, findsOneWidget);

    await widgetTester.enterText(nama, 'Danau Toba');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(deskripsi, 'Danau terindah di Indonesia');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(harga, '1000000');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(akomodasi, 'Hotel');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(durasi, '3');
    await widgetTester.pumpAndSettle();

    await widgetTester.drag(find.byType(ListView), Offset(0, -300));
    await widgetTester.pumpAndSettle();
    expect(pulau, findsOneWidget);
    expect(transportasi, findsOneWidget);

    await widgetTester.tap(pulau);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));
    await widgetTester.tap(find.text('Sumatera').last);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));
    await widgetTester.enterText(transportasi, 'Pesawat');
    await widgetTester.pumpAndSettle();

    //untuk scroll
    await widgetTester.drag(find.byType(ListView), Offset(0, -300));
    await widgetTester.pumpAndSettle();

    //untuk dropdown
    // final kategori = find
    //     .byWidgetPredicate((Widget widget) => widget is DropdownButton<String>);
    final kategori = find.byKey(Key('kategori'));
    expect(kategori, findsOneWidget);

    await widgetTester.tap(kategori);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));
    await widgetTester.tap(find.text('Maritim').last);
    await widgetTester.pumpAndSettle(Duration(seconds: 1));

    //untuk rating
    expect(rating, findsOneWidget);
    await widgetTester.tap(rating);
    await widgetTester.pumpAndSettle();

    // Ensure the login button is visible
    await widgetTester.ensureVisible(saveButton);
    await widgetTester.pumpAndSettle();

    // Tap the login button
    await widgetTester.tap(saveButton);
    await widgetTester.pumpAndSettle();

    final home = find.byKey(Key('home'));
    expect(home, findsOneWidget);
  });

  testWidgets('test objek failed', (widgetTester) async {
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
              builder: (context) => HomeView(),
            ),
          ),
        ),
        routes: AppRoutes.routes,
      ),
    ));
    await widgetTester.pumpAndSettle();

    final inputButton = find.byKey(Key('inputobjek'));
    expect(inputButton, findsOneWidget);
    await widgetTester.tap(inputButton);
    await widgetTester.pumpAndSettle();

    //----halaman input -----

    final nama = find.byKey(Key('nama'));
    final deskripsi = find.byKey(Key('deskripsi'));

    //pake rating bintang 5 (klu index kurang 1 dari bintang aslinya)
    final rating = find.byKey(Key('star4'));
    final saveButton = find.byKey(Key('simpan'));

    expect(nama, findsOneWidget);
    expect(deskripsi, findsOneWidget);

    await widgetTester.enterText(nama, 'x');
    await widgetTester.pumpAndSettle();
    await widgetTester.enterText(deskripsi, 'x');
    await widgetTester.pumpAndSettle();

    await widgetTester.drag(find.byType(ListView), Offset(0, -600));
    await widgetTester.pumpAndSettle();

    //untuk rating
    expect(rating, findsOneWidget);
    await widgetTester.tap(rating);
    await widgetTester.pumpAndSettle();

    // Ensure the login button is visible
    await widgetTester.ensureVisible(saveButton);
    await widgetTester.pumpAndSettle();

    // Tap the login button
    await widgetTester.tap(saveButton);
    await widgetTester.pumpAndSettle();

    await widgetTester.drag(find.byType(ListView), Offset(0, 300));
    await widgetTester.pumpAndSettle();
  });
}

class MyScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
