class User {
  final String? name;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? token;

  User(
      {this.name,
      this.password,
      this.email,
      this.phoneNumber,
      this.birthDate,
      this.token});

  @override
  String toString() {
    return 'User[name: $name, password: $password, email: $email, phoneNumber: $phoneNumber, birthDate: $birthDate, token: $token]';
  }
}
