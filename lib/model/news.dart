import 'dart:convert';

class News {
  final int? id;
  double? rating;
  String? namaDestinasi, deskripsi, provinsi, gambar;

  News({this.id, this.rating, this.namaDestinasi, this.deskripsi, this.provinsi, this.gambar});

  //untuk buat objek dari json yg diterima API
  factory News.fromRawJson(String str) => News.fromJson(json.decode(str));
  factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        rating: json["rating"].toDouble(),
        namaDestinasi: json["namaDestinasi"],
        deskripsi: json["deskripsi"],
        provinsi: json["provinsi"],
        gambar: json["gambar"],
      );

  //untuk buat json dari objek News yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() =>
      {"id": id, "rating": rating, "namaDestinasi": namaDestinasi, "deskripsi": deskripsi, "provinsi": provinsi, "gambar": gambar};
}
