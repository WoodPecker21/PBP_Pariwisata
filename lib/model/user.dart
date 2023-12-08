//import 'dart:typed_data';
import 'dart:convert';

class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? birthDate;
  final String? gender;
  String? imageProfile;

  User(
      {this.id,
      this.name,
      this.password,
      this.email,
      this.phoneNumber,
      this.birthDate,
      this.gender,
      this.imageProfile});

  @override
  String toString() {
    return 'User[id: $id, name: $name, password: $password, email: $email, phoneNumber: $phoneNumber, birthDate: $birthDate, gender: $gender ,imageProfile: $imageProfile]';
  }

  //untuk buat objek dari json yg diterima API
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      password: json["password"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      birthDate: json['birthDate'],
      gender: json["gender"],
      imageProfile: json["imageProfile"]);

  //untuk buat json dari objek barang yg akan dikirim ke API
  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthDate": birthDate,
        "gender": gender,
        "imageProfile": imageProfile,
      };
}
