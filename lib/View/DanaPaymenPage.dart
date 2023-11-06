import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ugd1/View/BayarPage.dart';

class DanaPaymentPage extends StatefulWidget {
  final double harga; // Price parameter

  DanaPaymentPage({required this.harga});

  @override
  _DanaPaymentPageState createState() => _DanaPaymentPageState(harga: harga);
}

class _DanaPaymentPageState extends State<DanaPaymentPage> {
  double harga;
  bool showPaymentForm = false; // State to control form visibility

  _DanaPaymentPageState({required this.harga});

  @override
  Widget build(BuildContext context) {
    final qrImage = QrImageView(
      data: 'Dana:$harga', // Use the price from the parameter
      version: QrVersions.auto,
      size: 200.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Dana Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dana Payment: RP $harga", // Display the price from the parameter
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              child: qrImage,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showPaymentForm = !showPaymentForm; // Toggle form visibility
                });
              },
              child: Text("Scan QR Code"),
            ),
            if (showPaymentForm)
              PaymentForm(
                harga: harga,
              ),
          ],
        ),
      ),
    );
  }
}
