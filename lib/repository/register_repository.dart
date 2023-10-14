import 'package:ugd1/model/user.dart';

class FailedRegister implements Exception {
  String errorMessage() {
    return "Register failed";
  }
}

class RegisterRepository {
  static List<User> userAccount = [];

  Future<List<User>> register(String username, String email, String password,
      String phoneNumber, DateTime birthDate) async {
    User userRegist = User();
    await Future.delayed(const Duration(seconds: 3), () {
      if (username.isNotEmpty &&
              email.isNotEmpty &&
              password.isNotEmpty &&
              phoneNumber.isNotEmpty
          // && birthDate.isNotEmpty
          ) {
        userRegist = User(
          name: username,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          birthDate: birthDate,
        );
        userAccount.add(userRegist);
        print(userRegist.name);
      } else {
        throw FailedRegister();
      }
    });
    return Future.value(userAccount);
  }
}
