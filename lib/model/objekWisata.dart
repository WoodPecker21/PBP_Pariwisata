import 'dart:convert';
import 'dart:io';

class ObjekWisata {
  final int? id;
  String? nama, deskripsi, kategori, gambar, pulau;
  double? rating, harga;
  String? akomodasi, transportasi;
  int? durasi;

  ObjekWisata(
      {this.id,
      this.nama,
      this.deskripsi,
      this.kategori,
      this.gambar,
      this.pulau,
      this.rating,
      this.harga,
      this.durasi,
      this.akomodasi,
      this.transportasi
      //   File? imageFile,
      // }) : _imageFile = imageFile {
      //   if (_imageFile != null) {
      //     image = base64Encode(_imageFile!.readAsBytesSync());
      //   }
      });

  factory ObjekWisata.fromRawJson(String str) =>
      ObjekWisata.fromJson(json.decode(str));

  factory ObjekWisata.fromJson(Map<String, dynamic> json) => ObjekWisata(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        kategori: json["kategori"],
        gambar: json["gambar"],
        pulau: json["pulau"],
        rating: json["rating"].toDouble(),
        harga: json["harga"].toDouble(),
        akomodasi: json["akomodasi"],
        transportasi: json["transportasi"],
        durasi: json["durasi"].toInt(),
      );

  String toRawJson() {
    Map<String, dynamic> rawJsonMap = {
      "id": id,
      "nama": nama,
      "deskripsi": deskripsi,
      "kategori": kategori,
      "gambar": gambar,
      "pulau": pulau,
      "rating": rating,
      "harga": harga,
      "akomodasi": akomodasi,
      "transportasi": transportasi,
      "durasi": durasi,
    };

    rawJsonMap.removeWhere((key, value) => value == null || value == '');

    return json.encode(rawJsonMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      "id": id,
      "nama": nama,
      "deskripsi": deskripsi,
      "kategori": kategori,
      "gambar": gambar,
      "pulau": pulau,
      "rating": rating,
      "harga": harga,
      "akomodasi": akomodasi,
      "transportasi": transportasi,
      "durasi": durasi,
    };

    jsonMap.removeWhere((key, value) => value == null || value == '');

    return jsonMap;
  }
}
