import 'dart:convert';

class ObjekWisata {
  final int? id;
  String? nama, deskripsi, kategori, gambar, pulau;
  double? rating, harga;
<<<<<<< HEAD
  String? akomodasi, transportasi;
=======
  String? akomodasi, fasilitas;
>>>>>>> 38a11da08c2f9e388c23b0b653b37e2cf2a8c65b
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
<<<<<<< HEAD
      transportasi: json["transportasi"],
=======
      fasilitas: json["fasilitas"],
>>>>>>> 38a11da08c2f9e388c23b0b653b37e2cf2a8c65b
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
<<<<<<< HEAD
        "transportasi": transportasi,
=======
        "fasilitas": fasilitas,
>>>>>>> 38a11da08c2f9e388c23b0b653b37e2cf2a8c65b
        "durasi": durasi,
      };
}
