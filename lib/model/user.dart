class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final String? birthDate;

  User(
      {this.id,
      this.name,
      this.password,
      this.email,
      this.phoneNumber,
      this.birthDate});

  @override
  String toString() {
    return 'User[id: $id, name: $name, password: $password, email: $email, phoneNumber: $phoneNumber, birthDate: $birthDate]';
  }
}
