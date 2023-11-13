class Transaksi {
  final int? id;
  final int? idUser;
  final int? idBayar;
  final String? name;
  final int? jumlahTamu;
  final String? email;
  final String? phoneNumber;
  final String? tglStart;

  Transaksi({
    this.id,
    this.idUser,
    this.idBayar,
    this.name,
    this.jumlahTamu,
    this.email,
    this.phoneNumber,
    this.tglStart,
  });

  @override
  String toString() {
    return 'Transaksi[id: $id, idUser: $idUser, idBayar: $idBayar, name: $name, jumlahTamu: $jumlahTamu, email: $email, phoneNumber: $phoneNumber ,tglStart: $tglStart]';
  }
}
