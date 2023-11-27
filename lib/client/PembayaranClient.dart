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

  //ambil sum pembayaran dari satu transaksi (bisa pembayaran normal + denda update tgl)
  static Future<Pembayaran> sumPembayaran(idTransaksi) async {
    try {
      var response =
          await get(Uri.http(url, '$endpoint/$idTransaksi')); //req ke api

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Pembayaran.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //membuat data baru
  static Future<int> create(Pembayaran objek) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {'Content-Type': 'application/json'},
          body: objek.toRawJson());
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return json.decode(response.body)['data']['id'];
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
}
