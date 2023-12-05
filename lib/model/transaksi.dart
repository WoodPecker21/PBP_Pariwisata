import 'dart:convert';
import 'package:ugd1/model/user.dart';
import 'package:ugd1/model/pembayaran.dart';
import 'package:ugd1/model/objekWisata.dart';

class Transaksi {
  final int? id;
  final int? idUser;
  final int? idBayar;
  final int? idObjek;
  final String? name;
  final int? jumlahTamu;
  final String? ktpNumber;
  final String? tglStart;

  // Additional fields for associations
  final User? user;
  final Pembayaran? bayar;
  final ObjekWisata? objek;

  Transaksi({
    this.id,
    this.idUser,
    this.idBayar,
    this.idObjek,
    this.name,
    this.jumlahTamu,
    this.ktpNumber,
    this.tglStart,
    this.user,
    this.bayar,
    this.objek,
  });

  @override
  String toString() {
    return 'Transaksi[id: $id, idUser: $idUser, idBayar: $idBayar, idObjekWisata: $idObjek, name: $name, jumlahTamu: $jumlahTamu, noktp: $ktpNumber, tglStart: $tglStart]';
  }

  // Factory methods for JSON serialization and deserialization
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
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        bayar:
            json["bayar"] != null ? Pembayaran.fromJson(json["bayar"]) : null,
        objek:
            json["objek"] != null ? ObjekWisata.fromJson(json["objek"]) : null,
      );

  // Methods for creating JSON from the object
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
        "user": user?.toJson(),
        "bayar": bayar?.toJson(),
        "objek": objek?.toJson(),
      };
}
