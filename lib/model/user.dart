import 'dart:typed_data';

class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? birthDate;
  final String? gender;
  final Uint8List? imageProfile;

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
}
