import 'dart:convert';

class News {
  final int? id;
  String? judul, isiBerita, gambar, pengarang;

  News({this.id, this.pengarang, this.judul, this.isiBerita, this.gambar});

  //untuk buat objek dari json yg diterima API
  factory News.fromRawJson(String str) => News.fromJson(json.decode(str));
  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        pengarang: json["pengarang"],
        judul: json["judul"],
        isiBerita: json["isiBerita"],
        gambar: json["gambar"],
      );

  //untuk buat json dari objek News yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() =>
      {"id": id, "pengarang": pengarang, "judul": judul, "isiBerita": isiBerita, "gambar": gambar};
}
