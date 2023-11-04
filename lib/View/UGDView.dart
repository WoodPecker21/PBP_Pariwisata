import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:ugd1/config/theme.dart';
import 'dart:math';

class UGD extends StatefulWidget {
  const UGD({super.key});

  @override
  State<UGD> createState() => _UGDState();
}

class _UGDState extends State<UGD> {
  bool isPromoReceived = false; // Flag untuk menunjukkan apakah promo diterima
  double initialPrice = 1000000.0; // Harga awal

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // Simulasi mendapatkan promo atau tidak
        isPromoReceived = _getPromoStatus();

        // Tampilkan pop-up card
        _showPromoCard();
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  // Fungsi untuk menentukan apakah promo diterima atau tidak (gunakan logika sesuai kebutuhan)
  bool _getPromoStatus() {
    // Contoh logika sederhana: 50% kesempatan mendapatkan promo
    return (Random().nextInt(2) == 0);
  }

  // Fungsi untuk menampilkan pop-up card
  void _showPromoCard() {
    String message = isPromoReceived
        ? "Selamat! Anda mendapatkan potongan harga. Harga awal: \$${initialPrice.toStringAsFixed(2)}, Harga setelah diskon: \$${(initialPrice / 2).toStringAsFixed(2)}"
        : "Maaf, Anda tidak mendapatkan promo.";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Promo Result'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Harga Awal: \$${initialPrice.toStringAsFixed(2)}"),
      ),
    );
  }
}