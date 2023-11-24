import 'dart:convert';

class ObjekWisata {
  final int? id;
  String? nama, deskripsi, kategori, gambar;
  double? rating, harga;
  String? akomodasi, fasilitas;
  int? durasi;

  ObjekWisata(
      {this.id,
      this.nama,
      this.deskripsi,
      this.kategori,
      this.gambar,
      this.rating,
      this.harga,
      this.durasi,
      this.akomodasi,
      this.fasilitas});

  //untuk buat objek dari json yg diterima API
  factory ObjekWisata.fromRawJson(String str) =>
      ObjekWisata.fromJson(json.decode(str));
  factory ObjekWisata.fromJson(Map<String, dynamic> json) => ObjekWisata(
      id: json["id"],
      nama: json["nama"],
      deskripsi: json["deskripsi"],
      kategori: json["kategori"],
      gambar: json["gambar"],
      rating: json["rating"],
      harga: json["harga"],
      akomodasi: json["akomodasi"],
      fasilitas: json["fasilitas"],
      durasi: json["durasi"]);

  //untuk buat json dari objek barang yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "deskripsi": deskripsi,
        "kategori": kategori,
        "gambar": gambar,
        "rating": rating,
        "harga": harga,
        "akomodasi": akomodasi,
        "fasilitas": fasilitas,
        "durasi": durasi,
      };
}
