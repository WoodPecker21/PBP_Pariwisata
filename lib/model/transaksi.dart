import 'dart:convert';

class Transaksi {
  final int? id;
  final int? idUser;
  final int? idBayar;
  final int? idObjek;
  final String? name;
  final int? jumlahTamu;
  final String? ktpNumber;
  final String? tglStart;

  Transaksi({
    this.id,
    this.idUser,
    this.idBayar,
    this.idObjek,
    this.name,
    this.jumlahTamu,
    this.ktpNumber,
    this.tglStart,
  });

  @override
  String toString() {
    return 'Transaksi[id: $id, idUser: $idUser, idBayar: $idBayar, idObjekWisata: $idObjek, name: $name, jumlahTamu: $jumlahTamu, noktp: $ktpNumber, tglStart: $tglStart]';
  }

  //untuk buat objek dari json yg diterima API
  factory Transaksi.fromRawJson(String str) =>
      Transaksi.fromJson(json.decode(str));
  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        id: json["id"],
        idUser: json["idUser"],
        idBayar: json["idBayar"],
        idObjek: json["idObjek"],
        name: json["name"],
        jumlahTamu: json["jumlahTamu"],
        ktpNumber: json["ktpNumber"],
        tglStart: json["tglStart"],
      );

  //untuk buat json dari objek barang yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "idUser": idUser,
        "idBayar": idBayar,
        "idObjek": idObjek,
        "name": name,
        "jumlahTamu": jumlahTamu,
        "ktpNumber": ktpNumber,
        "tglStart": tglStart,
      };
}
