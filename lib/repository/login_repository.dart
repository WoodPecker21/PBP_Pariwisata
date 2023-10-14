import 'package:ugd1/repository/register_repository.dart';

import '../model/user.dart';

class FailedLogin implements Exception {
  String errorMessage() {
    return 'Login failed';
  }
}

class LoginRepository {
  Future<User> login(String username, String password) async {
    bool isUserRegistered = false;
    User? user; // Ini akan menyimpan data pengguna jika ditemukan.
    
    // Cari pengguna dalam data register.
    for (int i = 0; i < RegisterRepository.userAccount.length; i++) {
      if (RegisterRepository.userAccount[i].name == username &&
          RegisterRepository.userAccount[i].password == password) {
        isUserRegistered = true;
        user = RegisterRepository.userAccount[i];
        break;
      }
    }

    await Future.delayed(Duration(seconds: 2));

    if (isUserRegistered) {
      return Future.value(user); // Kembalikan objek User dalam Future.value.
    } else {
      throw FailedLogin();
    }
  }
}
