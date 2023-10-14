abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final DateTime birthDate;

  RegisterButtonPressed({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.birthDate,
  });
}

class IsPasswordVisibleChanged extends RegisterEvent {}
