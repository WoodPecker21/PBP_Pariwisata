import 'dart:convert';

class Pembayaran {
  final int? id;
  double? price;
  String? metode;

  Pembayaran({this.id, this.price, this.metode});

  //untuk buat objek dari json yg diterima API
  factory Pembayaran.fromRawJson(String str) =>
      Pembayaran.fromJson(json.decode(str));
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
        id: json["id"],
        price: json["price"],
        metode: json["metode"],
      );

  //untuk buat json dari objek pembayaran yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "metode": metode,
      };
}
