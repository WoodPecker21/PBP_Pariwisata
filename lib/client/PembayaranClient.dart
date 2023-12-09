import 'package:ugd1/model/pembayaran.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ugd1/client/UrlClient.dart';

class PembayaranClient {
  static final String url = UrlClient.baseurl;
  static final String endpoint = UrlClient.endpoint + UrlClient.pembayaran;
  //ambil semua data barang dari api
  static Future<List<Pembayaran>> fetchAll() async {
    try {
      var response = await get(
          Uri.http(url, endpoint)); // request ke api dan menyimpan responsenya

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //ambil data dari response body
      Iterable list = json.decode(response.body)['data'];

      //list map utk membuat list obejk user berdasar tiap elemen dari list
      return list.map((e) => Pembayaran.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //ambil data dari API sesuai id
  static Future<Pembayaran> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //req ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      //buat objek berdasarkan data dari response body
      return Pembayaran.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //membuat data baru
  static Future<int?> create(Pembayaran objek) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {'Content-Type': 'application/json'},
        body: objek.toRawJson(),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        int id = json.decode(response.body)['data']['id'];
        return id;
      } else {
        throw Exception(response.reasonPhrase);
      }
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

  static Future<Pembayaran> updateDenda(int idBooking, double priceNew) async {
    try {
      String endpointUpdateDenda = UrlClient.endpoint + UrlClient.updateDenda;

      var urlfin = Uri.http(url, '$endpointUpdateDenda/$idBooking');

      var response = await put(
        urlfin,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'price': priceNew}),
      );
      print(response.body);

      if (response.statusCode == 200) {
        Pembayaran p = Pembayaran.fromJson(json.decode(response.body));
        return p;
      } else {
        var errorResponse = json.decode(response.body);
        var errorMessage = errorResponse['message'];
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('error client: $e');
      throw Exception(e.toString());
    }
  }
}
