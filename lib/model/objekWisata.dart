import 'dart:convert';

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
      this.transportasi});

  //untuk buat objek dari json yg diterima API
  factory ObjekWisata.fromRawJson(String str) =>
      ObjekWisata.fromJson(json.decode(str));
  factory ObjekWisata.fromJson(Map<String, dynamic> json) => ObjekWisata(
      id: json["id"],
      nama: json["nama"],
      deskripsi: json["deskripsi"],
      kategori: json["kategori"],
      gambar: json["gambar"],
      pulau: json["pulau"],
      rating: json["rating"].toDouble(), // Cast to double
      harga: json["harga"].toDouble(), // Cast to double
      akomodasi: json["akomodasi"],
      transportasi: json["transportasi"],
      durasi: json["durasi"]);

  //untuk buat json dari objek barang yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
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
}
