import 'package:flutter/material.dart';
import 'package:ugd1/View/DanaPaymenPage.dart';
import 'package:ugd1/View/scanEmoney.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:core';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
      ),
      body: ListView(
        children: [
          PaymentMethodItem(
            title: "Scan QR Code",
            icon: Icons.credit_card,
          ),
          PaymentMethodItem(
            title: "Generate QR Code",
            icon: Icons.payment,
          ),
        ],
      ),
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const PaymentMethodItem({
    required this.title,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () async {
          if (title == "Generate QR Code") {
            //masukkan harga sesuai dengan pembayaran di booking
            final prefs = await SharedPreferences.getInstance();
            double totalHarga = prefs.getDouble('bookingTotalHarga') ?? 0;
            final harga = totalHarga;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DanaPaymentPage(harga: harga),
              ),
            );
          } else if (title == "Scan QR Code") {
            // Mengarahkan ke scan_qr_page.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarcodeScannerPageView(),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Method Selected"),
                  content:
                      Text("You have selected $title as your payment method."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
