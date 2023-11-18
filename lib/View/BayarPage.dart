import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  final double harga;

  PaymentForm({required this.harga});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  double uangYangDibayar = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Total Harga: RP ${widget.harga.toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: "Jumlah Uang"),
                  keyboardType: TextInputType.number,
                  onChanged: (input) {
                    setState(() {
                      uangYangDibayar = double.tryParse(input) ?? 0.0;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Validasi pembayaran
                    if (uangYangDibayar >= widget.harga) {
                      // Jika jumlah uang mencukupi
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Pembayaran Sukses"),
                            content: Text(
                                "Pembayaran sebesar RP ${widget.harga.toStringAsFixed(2)} telah diterima."),
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
                    } else {
                      // Jika jumlah uang tidak mencukupi
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Pembayaran Gagal"),
                            content: Text(
                                "Jumlah uang yang dibayarkan tidak mencukupi."),
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
                  child: Text("Bayar"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
