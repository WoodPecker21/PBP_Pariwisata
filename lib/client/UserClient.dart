import 'package:ugd1/model/user.dart';
import 'package:http/http.dart';
import 'dart:convert';

class UserClient {
  //untuk device hp
  static final String url = '192.168.168.56';
  static final String endpoint = '/LaravelAPI_Pariwisata/public/api/user';

  //ambil semua data barang dari api
  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(
          Uri.http(url, endpoint)); // request ke api dan menyimpan responsenya

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //ambil data dari response body
      Iterable list = json.decode(response.body)['data'];

      //list map utk membuat list obejk user berdasar tiap elemen dari list
      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //ambil data dari API sesuai id
  static Future<User> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //req ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //buat objek berdasarkan data dari response body
      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //membuat data baru
  static Future<Response> create(User user) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {'Content-Type': 'application/json'},
          body: user.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //mengubaah data sesuai id
  static Future<Response> update(User user) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${user.id}'),
          headers: {'Content-Type': 'application/json'},
          body: user.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //menghapus data sesuai id
  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<int?> searchUser(String nameInput, String passwordInput) async {
    try {
      var response = await get(
        Uri.http(url, endpoint),
      );

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];

      for (final userJson in list) {
        final user = User.fromJson(userJson);
        if (user.name == nameInput && user.password == passwordInput) {
          return user.id;
        }
      }

      return -1; // No user found with the provided name and password
    } catch (e) {
      return -1; // Handle errors
    }
  }

  static Future<bool> cekEmailUnik(String emailInput) async {
    try {
      var response = await get(
        Uri.http(url, endpoint),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      Iterable list = json.decode(response.body)['data'];
      if (list.isEmpty) {
        return true; // Database is empty, treat it as unique
      }

      for (final userJson in list) {
        final user = User.fromJson(userJson);
        if (user.email == emailInput) {
          print('masuk ke list db');
          return false; //berarti tidak unik
        }
      }

      return true; //berarti unik
    } catch (e) {
      print('error client: $e');
      return false;
    }
  }
}
